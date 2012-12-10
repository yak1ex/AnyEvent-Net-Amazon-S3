package AnyEvent::Net::Amazon::S3::Client::Object;

# ABSTRACT: An easy-to-use Amazon S3 client object
# VERSION

use strict;
use warnings;

# TODO: _content_sub might become more async manner?
# NOTE: exists and delete have HIGH risk.
use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3::Client::Object',
        -transformer => 'Net::Amazon::S3',
        -translate_func => [qw(exists get get_filename put put_filename delete
                               initiate_multipart_upload complete_multipart_upload put_part)],
        -replace_func => [qw(_send_request_raw _send_request _send_request_xpc)]
;

1;

__END__

=for test_synopsis
no strict 'vars';
no warnings;

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

This module provides the same interface as L<Net::Amazon::S3::Client::Object>.
In addition, some asynchronous methods returning AnyEvent condition variable are added.

=head1 METHODS

All L<Net::Amazon::S3::Client::Bucket> methods are available.
In addition, there are the following asynchronous methods.
Arguments of the methods are identical as original but return value becomes L<AnyEvent> condition variable.
You can get actual return value by calling C<shift-E<gt>recv()>.

=for :list
= delete_async
= exists_async
= get_async
= get_filename_async
= put_async
= put_filename_async
= complete_multipart_upload_async
= initiate_multipart_upload_async
= put_part_async

=begin Pod::Coverage

list_parts
query_string_authentication_uri
uri

=end Pod::Coverage
