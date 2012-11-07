package AnyEvent::Net::Amazon::S3::Client;

# ABSTRACT: An easy-to-use Amazon S3 client

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3::Client',
        -transformer => 'Net::Amazon::S3',
        -translate_func => [qw(@buckets create_bucket _send_request_raw _send_request _send_request_content _send_request_xpc)],
        -replace_func => [qw(_create request)]
;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $s3 = AnyEvent::Net::Amazon::S3->new(
    aws_access_key_id     => $aws_access_key_id,
    aws_secret_access_key => $aws_secret_access_key,
    retry                 => 1,
  );
  my $client = AnyEvent::Net::Amazon::S3::Client->new( s3 => $s3 );

  # list all my buckets
  # returns a list of L<AnyEvent::Net::Amazon::S3::Client::Bucket> objects
  my @buckets = $client->buckets;
  foreach my $bucket (@buckets) {
    print $bucket->name . "\n";
  }

  # create a new bucket
  # returns a L<AnyEvent::Net::Amazon::S3::Client::Bucket> object
  my $bucket = $client->create_bucket(
    name                => $bucket_name,
    acl_short           => 'private',
    location_constraint => 'US',
  );

  # or use an existing bucket
  # returns a L<AnyEvent::Net::Amazon::S3::Client::Bucket> object
  my $bucket = $client->bucket( name => $bucket_name );

=head1 DESCRIPTION

The L<AnyEvent::Net::Amazon::S3> module was written when the Amazon S3 service
had just come out and it is a light wrapper around the APIs. Some
bad API decisions were also made. The
L<AnyEvent::Net::Amazon::S3::Client>, L<AnyEvent::Net::Amazon::S3::Client::Bucket> and
L<AnyEvent::Net::Amazon::S3::Client::Object> classes are designed after years
of usage to be easy to use for common tasks.

These classes throw an exception when a fatal error occurs. It
also is very careful to pass an MD5 of the content when uploaded
to S3 and check the resultant ETag.

WARNING: This is an early release of the Client classes, the APIs
may change.

=head1 METHODS

=head2 buckets

  # list all my buckets
  # returns a list of L<AnyEvent::Net::Amazon::S3::Client::Bucket> objects
  my @buckets = $client->buckets;
  foreach my $bucket (@buckets) {
    print $bucket->name . "\n";
  }

=head2 create_bucket

  # create a new bucket
  # returns a L<AnyEvent::Net::Amazon::S3::Client::Bucket> object
  my $bucket = $client->create_bucket(
    name                => $bucket_name,
    acl_short           => 'private',
    location_constraint => 'US',
  );

=head2 bucket

  # or use an existing bucket
  # returns a L<AnyEvent::Net::Amazon::S3::Client::Bucket> object
  my $bucket = $client->bucket( name => $bucket_name );

