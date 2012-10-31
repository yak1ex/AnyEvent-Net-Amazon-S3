package AnyEvent::Net::Amazon::S3::Client::Object;

# ABSTRACT: An easy-to-use Amazon S3 client object

use strict;
use warnings;

# TODO: Replace relevant package name
#     * Net::Amazon::S3::Request::GetObject
#     * Net::Amazon::S3::Request::PutObject
#     * Net::Amazon::S3::Request::DeleteObject
# TODO: _content_sub might become more async manner?
# NOTE: exists and delete have HIGH risk.
use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3::Client::Object',
	-translate_func => [qw(exists get get_filename put put_filename delete)],
	-replace_func => [qw(_send_request_raw _send_request)]
;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  # show the key
  print $object->key . "\n";

  # show the etag of an existing object (if fetched by listing
  # a bucket)
  print $object->etag . "\n";

  # show the size of an existing object (if fetched by listing
  # a bucket)
  print $object->size . "\n";

  # to create a new object
  my $object = $bucket->object( key => 'this is the key' );
  $object->put('this is the value');

  # to get the vaue of an object
  my $value = $object->get;

  # to see if an object exists
  if ($object->exists) { ... }

  # to delete an object
  $object->delete;

  # to create a new object which is publically-accessible with a
  # content-type of text/plain which expires on 2010-01-02
  my $object = $bucket->object(
    key          => 'this is the public key',
    acl_short    => 'public-read',
    content_type => 'text/plain',
    expires      => '2010-01-02',
  );
  $object->put('this is the public value');

  # return the URI of a publically-accessible object
  my $uri = $object->uri;

  # upload a file
  my $object = $bucket->object(
    key          => 'images/my_hat.jpg',
    content_type => 'image/jpeg',
  );
  $object->put_filename('hat.jpg');

  # upload a file if you already know its md5_hex and size
  my $object = $bucket->object(
    key          => 'images/my_hat.jpg',
    content_type => 'image/jpeg',
    etag         => $md5_hex,
    size         => $size,
  );
  $object->put_filename('hat.jpg');

  # download the value of the object into a file
  my $object = $bucket->object( key => 'images/my_hat.jpg' );
  $object->get_filename('hat_backup.jpg');

  # use query string authentication
  my $object = $bucket->object(
    key          => 'images/my_hat.jpg',
    expires      => '2009-03-01',
  );
  my $uri = $object->query_string_authentication_uri();

=head1 DESCRIPTION

This module represents objects in buckets.

=head1 METHODS

=head2 etag

  # show the etag of an existing object (if fetched by listing
  # a bucket)
  print $object->etag . "\n";

=head2 delete

  # to delete an object
  $object->delete;

=head2 exists

  # to see if an object exists
  if ($object->exists) { ... }

=head2 get

  # to get the vaue of an object
  my $value = $object->get;

=head2 get_filename

  # download the value of the object into a file
  my $object = $bucket->object( key => 'images/my_hat.jpg' );
  $object->get_filename('hat_backup.jpg');

=head2 key

  # show the key
  print $object->key . "\n";

=head2 put

  # to create a new object
  my $object = $bucket->object( key => 'this is the key' );
  $object->put('this is the value');

  # to create a new object which is publically-accessible with a
  # content-type of text/plain
  my $object = $bucket->object(
    key          => 'this is the public key',
    acl_short    => 'public-read',
    content_type => 'text/plain',
  );
  $object->put('this is the public value');

You may also set Content-Encoding using content_encoding, and
Content-Disposition using content_disposition.

=head2 put_filename

  # upload a file
  my $object = $bucket->object(
    key          => 'images/my_hat.jpg',
    content_type => 'image/jpeg',
  );
  $object->put_filename('hat.jpg');

  # upload a file if you already know its md5_hex and size
  my $object = $bucket->object(
    key          => 'images/my_hat.jpg',
    content_type => 'image/jpeg',
    etag         => $md5_hex,
    size         => $size,
  );
  $object->put_filename('hat.jpg');

You may also set Content-Encoding using content_encoding, and
Content-Disposition using content_disposition.

=head2 query_string_authentication_uri

  # use query string authentication
  my $object = $bucket->object(
    key          => 'images/my_hat.jpg',
    expires      => '2009-03-01',
  );
  my $uri = $object->query_string_authentication_uri();

=head2 size

  # show the size of an existing object (if fetched by listing
  # a bucket)
  print $object->size . "\n";

=head2 uri

  # return the URI of a publically-accessible object
  my $uri = $object->uri;

