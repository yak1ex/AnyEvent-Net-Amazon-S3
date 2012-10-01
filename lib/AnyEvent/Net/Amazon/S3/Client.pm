package AnyEvent::Net::Amazon::S3::Client;
use Moose 0.85;
use HTTP::Status qw(is_error status_message);
use MooseX::StrictConstructor 0.16;
use Moose::Util::TypeConstraints;
use Net::Amazon::S3::Client;
use AnyEvent;

# ABSTRACT: An easy-to-use Amazon S3 client

extends 'Net::Amazon::S3';

has 's3' => ( is => 'ro', isa => 'AnyEvent::Net::Amazon::S3', required => 1 );

__PACKAGE__->meta->make_immutable;

sub buckets_async {
    my $self = shift;
    my $s3   = $self->s3;

    my $http_request
        = AnyEvent::Net::Amazon::S3::Request::ListAllMyBuckets->new( s3 => $s3 )
        ->http_request;

    my $cv = AE::cv;
    $self->_send_request_xpc_async($http_request)->cb(sub { $cv->send(sub {

    my $xpc = shift->recv;

    my $owner_id
        = $xpc->findvalue('/s3:ListAllMyBucketsResult/s3:Owner/s3:ID');
    my $owner_display_name = $xpc->findvalue(
        '/s3:ListAllMyBucketsResult/s3:Owner/s3:DisplayName');

    my @buckets;
    foreach my $node (
        $xpc->findnodes('/s3:ListAllMyBucketsResult/s3:Buckets/s3:Bucket') )
    {
        push @buckets,
            AnyEvent::Net::Amazon::S3::Client::Bucket->new(
            {   client => $self,
                name   => $xpc->findvalue( './s3:Name', $node ),
                creation_date =>
                    $xpc->findvalue( './s3:CreationDate', $node ),
                owner_id           => $owner_id,
                owner_display_name => $owner_display_name,
            }
            );

    }
    return @buckets;

    }->(shift))});
    return $cv;
}
sub buckets {
    return shift->buckets_async(@_)->recv;
}

sub create_bucket_async {
    my ( $self, %conf ) = @_;

    my $bucket = AnyEvent::Net::Amazon::S3::Client::Bucket->new(
        client => $self,
        name   => $conf{name},
    );
    my $cv = AE::cv;
    $bucket->_create_async(
        acl_short           => $conf{acl_short},
        location_constraint => $conf{location_constraint},
    )->cb(sub { $cv->send($bucket) });
    return $cv;
}
sub create_bucket {
    return shift->create_bucket_async(@_)->recv;
}

sub _send_request_raw_async {
    my ( $self, $http_request, $filename ) = @_;

    return $self->s3->ua->request_async( $http_request, $filename );
}
sub _send_request_raw {
	return shift->_send_request_raw_async(@_)->recv;
}

sub _send_request_async {
    my ( $self, $http_request, $filename ) = @_;

    my $cv = AE::cv;
    $self->_send_request_raw_async( $http_request, $filename )->cb(sub { $cv->send(sub {

    my $http_response = shift->recv;

    my $content      = $http_response->content;
    my $content_type = $http_response->content_type;
    my $code         = $http_response->code;

    if ( is_error($code) ) {
        if ( $content_type eq 'application/xml' ) {
            my $doc = $self->s3->libxml->parse_string($content);
            my $xpc = XML::LibXML::XPathContext->new($doc);
            $xpc->registerNs( 's3',
                'http://s3.amazonaws.com/doc/2006-03-01/' );

            if ( $xpc->findnodes('/Error') ) {
                my $code    = $xpc->findvalue('/Error/Code');
                my $message = $xpc->findvalue('/Error/Message');
                confess("$code: $message");
            } else {
                confess status_message($code);
            }
        } else {
            confess status_message($code);
        }
    }
    return $http_response;

    }->(shift))});
    return $cv;
}
sub _send_request {
    return shift->_send_request_async(@_)->recv;
}

sub _send_request_content_async {
    my ( $self, $http_request, $filename ) = @_;
    my $cv = AE::cv;
    $self->_send_request_async( $http_request, $filename )->cb(sub { $cv->send(sub {

    my $response = shift->recv;
    return $response->content;

    }->(shift))});
    return $cv;
}
sub _send_request_content {
    return shift->_send_request_content_async(@_)->recv;
}

sub _send_request_xpc_async {
    my ( $self, $http_request, $filename ) = @_;
    my $cv = AE::cv;
    $self->_send_request_async( $http_request, $filename )->cb(sub { $cv->send(sub {

    my $http_response = shift->recv;

    my $doc = $self->s3->libxml->parse_string( $http_response->content );
    my $xpc = XML::LibXML::XPathContext->new($doc);
    $xpc->registerNs( 's3', 'http://s3.amazonaws.com/doc/2006-03-01/' );

    return $xpc;

    }->(shift))});
    return $cv;
}
sub _send_request_xpc {
    return shift->_send_request_xpc(@_)->recv;
}

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

