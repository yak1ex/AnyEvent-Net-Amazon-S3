package AnyEvent::Net::Amazon::S3;

# ABSTRACT: Use the Amazon S3 - Simple Storage Service

=head1 SYNOPSIS

  use AnyEvent::Net::Amazon::S3;
  my $aws_access_key_id     = 'fill me in';
  my $aws_secret_access_key = 'fill me in too';

  my $s3 = AnyEvent::Net::Amazon::S3->new(
      {   aws_access_key_id     => $aws_access_key_id,
          aws_secret_access_key => $aws_secret_access_key,
          retry                 => 1,
      }
  );

  # a bucket is a globally-unique directory
  # list all buckets that i own
  my $response = $s3->buckets;
  foreach my $bucket ( @{ $response->{buckets} } ) {
      print "You have a bucket: " . $bucket->bucket . "\n";
  }

  # create a new bucket
  my $bucketname = 'acmes_photo_backups';
  my $bucket = $s3->add_bucket( { bucket => $bucketname } )
      or die $s3->err . ": " . $s3->errstr;

  # or use an existing bucket
  $bucket = $s3->bucket($bucketname);

  # store a file in the bucket
  $bucket->add_key_filename( '1.JPG', 'DSC06256.JPG',
      { content_type => 'image/jpeg', },
  ) or die $s3->err . ": " . $s3->errstr;

  # store a value in the bucket
  $bucket->add_key( 'reminder.txt', 'this is where my photos are backed up' )
      or die $s3->err . ": " . $s3->errstr;

  # list files in the bucket
  $response = $bucket->list_all
      or die $s3->err . ": " . $s3->errstr;
  foreach my $key ( @{ $response->{keys} } ) {
      my $key_name = $key->{key};
      my $key_size = $key->{size};
      print "Bucket contains key '$key_name' of size $key_size\n";
  }

  # fetch file from the bucket
  $response = $bucket->get_key_filename( '1.JPG', 'GET', 'backup.jpg' )
      or die $s3->err . ": " . $s3->errstr;

  # fetch value from the bucket
  $response = $bucket->get_key('reminder.txt')
      or die $s3->err . ": " . $s3->errstr;
  print "reminder.txt:\n";
  print "  content length: " . $response->{content_length} . "\n";
  print "    content type: " . $response->{content_type} . "\n";
  print "            etag: " . $response->{content_type} . "\n";
  print "         content: " . $response->{value} . "\n";

  # delete keys
  $bucket->delete_key('reminder.txt') or die $s3->err . ": " . $s3->errstr;
  $bucket->delete_key('1.JPG')        or die $s3->err . ": " . $s3->errstr;

  # and finally delete the bucket
  $bucket->delete_bucket or die $s3->err . ": " . $s3->errstr;

=head1 DESCRIPTION

This module provides a Perlish interface to Amazon S3. From the
developer blurb: "Amazon S3 is storage for the Internet. It is
designed to make web-scale computing easier for developers. Amazon S3
provides a simple web services interface that can be used to store and
retrieve any amount of data, at any time, from anywhere on the web. It
gives any developer access to the same highly scalable, reliable,
fast, inexpensive data storage infrastructure that Amazon uses to run
its own global network of web sites. The service aims to maximize
benefits of scale and to pass those benefits on to developers".

To find out more about S3, please visit: http://s3.amazonaws.com/

To use this module you will need to sign up to Amazon Web Services and
provide an "Access Key ID" and " Secret Access Key". If you use this
module, you will incurr costs as specified by Amazon. Please check the
costs. If you use this module with your Access Key ID and Secret
Access Key you must be responsible for these costs.

I highly recommend reading all about S3, but in a nutshell data is
stored in values. Values are referenced by keys, and keys are stored
in buckets. Bucket names are global.

Note: This is the legacy interface, please check out
L<AnyEvent::Net::Amazon::S3::Client> instead.

Development of this code happens here: http://github.com/pfig/net-amazon-s3/

Homepage for the project (just started) is at http://pfig.github.com/net-amazon-s3/

=cut

use strict;
use warnings;

use Carp;

use Module::AnyEvent::Helper;

use AnyEvent::HTTP::LWP::UserAgent;
use AnyEvent::HTTP::LWP::UserAgent::Determined;
use XML::LibXML;
use AnyEvent;

=head1 METHODS

=head2 new

Create a new S3 client object. Takes some arguments:

=over

=item aws_access_key_id

Use your Access Key ID as the value of the AWSAccessKeyId parameter
in requests you send to Amazon Web Services (when required). Your
Access Key ID identifies you as the party responsible for the
request.

=item aws_secret_access_key

Since your Access Key ID is not encrypted in requests to AWS, it
could be discovered and used by anyone. Services that are not free
require you to provide additional information, a request signature,
to verify that a request containing your unique Access Key ID could
only have come from you.

DO NOT INCLUDE THIS IN SCRIPTS OR APPLICATIONS YOU DISTRIBUTE. YOU'LL BE SORRY

=item secure

Set this to C<1> if you want to use SSL-encrypted connections when talking
to S3. Defaults to C<0>.

=item timeout

How many seconds should your script wait before bailing on a request to S3? Defaults
to 30.

=item retry

If this library should retry upon errors. This option is recommended.
This uses exponential backoff with retries after 1, 2, 4, 8, 16, 32 seconds,
as recommended by Amazon. Defaults to off.

=back

=cut

my $KEEP_ALIVE_CACHESIZE = 10;

sub BUILD {
    my $self = shift;

    my $ua;
    if ( $self->retry ) {
        $ua = AnyEvent::HTTP::LWP::UserAgent::Determined->new(
            keep_alive            => $KEEP_ALIVE_CACHESIZE,
            requests_redirectable => [qw(GET HEAD DELETE PUT)],
        );
        $ua->timing('1,2,4,8,16,32');
    } else {
        $ua = AnyEvent::HTTP::LWP::UserAgent->new(
            keep_alive            => $KEEP_ALIVE_CACHESIZE,
            requests_redirectable => [qw(GET HEAD DELETE PUT)],
        );
    }

    $ua->timeout( $self->timeout );
    $ua->env_proxy;

    $self->ua($ua);
    $self->libxml( XML::LibXML->new ); # Set in superclass
}

sub list_bucket_all_async {
    my ( $self, $conf ) = @_;
    $conf ||= {};
    my $bucket = $conf->{bucket};
    croak 'must specify bucket' unless $bucket;

    my $cv = AE::cv;
    Module::AnyEvent::Helper::bind_scalar($self->list_bucket_async($conf), sub {

        my $response = shift->recv;
        return $response unless $response->{is_truncated};
        my $all = $response;

        my $iter; $iter = sub {
            my $next_marker = $response->{next_marker}
                || $response->{keys}->[-1]->{key};
            $conf->{marker} = $next_marker;
            $conf->{bucket} = $bucket;
            Module::AnyEvent::Helper::bind_scalar($self->list_bucket_async($conf), sub {
                $response       = shift->recv;
                push @{ $all->{keys} }, @{ $response->{keys} };
                if($response->{is_truncated}) {
                    $iter->();
                } else {
                    delete $all->{is_truncated};
                    delete $all->{next_marker};
                    return $all;
                }
            });
        };
        $iter->();
    });
    return $cv;
}

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3',
        -remove_func => [qw(list_bucket_all)],
        -translate_func => [qw(buckets add_bucket delete_bucket list_bucket add_key get_key head_key delete_key _send_request _do_http _send_request_expect_nothing _send_request_expect_nothing_probed)],
        -replace_func => [qw(request)],
        -delete_func => [qw(BUILD)]
;

1;

__END__

=head1 LICENSE

This module contains code modified from Amazon that contains the
following notice:

  #  This software code is made available "AS IS" without warranties of any
  #  kind.  You may copy, display, modify and redistribute the software
  #  code either by itself or as incorporated into your code; provided that
  #  you do not remove any proprietary notices.  Your use of this software
  #  code is at your own risk and you waive any claim against Amazon
  #  Digital Services, Inc. or its affiliates with respect to your use of
  #  this software code. (c) 2006 Amazon Digital Services, Inc. or its
  #  affiliates.

=head1 TESTING

Testing S3 is a tricky thing. Amazon wants to charge you a bit of
money each time you use their service. And yes, testing counts as using.
Because of this, the application's test suite skips anything approaching
a real test unless you set these three environment variables:

=over

=item AMAZON_S3_EXPENSIVE_TESTS

Doesn't matter what you set it to. Just has to be set

=item AWS_ACCESS_KEY_ID

Your AWS access key

=item AWS_ACCESS_KEY_SECRET

Your AWS sekkr1t passkey. Be forewarned that setting this environment variable
on a shared system might leak that information to another user. Be careful.

=back

=head1 AUTHOR

Leon Brocard <acme@astray.com> and unknown Amazon Digital Services programmers.

Brad Fitzpatrick <brad@danga.com> - return values, Bucket object

Pedro Figueiredo <me@pedrofigueiredo.org> - since 0.54

=head1 SEE ALSO

L<AnyEvent::Net::Amazon::S3::Bucket>

