package AnyEvent::Net::Amazon::S3::Bucket;

# ABSTRACT: convenience object for working with Amazon S3 buckets
# VERSION

use strict;
use warnings;

# TODO: _content_sub might become more async manner?

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3::Bucket',
        -transformer => 'Net::Amazon::S3',
        -translate_func => [qw(add_key add_key_filename copy_key edit_metadata head_key get_key get_key_filename delete_key delete_bucket list list_all get_acl set_acl get_location_constraint)],
        -replace_func => [qw(_send_request_expect_nothing_probed list_bucket list_bucket_all _do_http _send_request_expect_nothing _send_request)]
;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  use AnyEvent::Net::Amazon::S3;

  my $bucket = $s3->bucket("foo");

  ok($bucket->add_key("key", "data"));
  ok($bucket->add_key("key", "data", {
     content_type => "text/html",
    'x-amz-meta-colour' => 'orange',
  }));

  # the err and errstr methods just proxy up to the AnyEvent::Net::Amazon::S3's
  # objects err/errstr methods.
  $bucket->add_key("bar", "baz") or
      die $bucket->err . $bucket->errstr;

  # fetch a key
  $val = $bucket->get_key("key");
  is( $val->{value},               'data' );
  is( $val->{content_type},        'text/html' );
  is( $val->{etag},                'b9ece18c950afbfa6b0fdbfa4ff731d3' );
  is( $val->{'x-amz-meta-colour'}, 'orange' );

  # returns undef on missing or on error (check $bucket->err)
  is(undef, $bucket->get_key("non-existing-key"));
  die $bucket->errstr if $bucket->err;

  # fetch a key's metadata
  $val = $bucket->head_key("key");
  is( $val->{value},               '' );
  is( $val->{content_type},        'text/html' );
  is( $val->{etag},                'b9ece18c950afbfa6b0fdbfa4ff731d3' );
  is( $val->{'x-amz-meta-colour'}, 'orange' );

  # delete a key
  ok($bucket->delete_key($key_name));
  ok(! $bucket->delete_key("non-exist-key"));

  # delete the entire bucket (Amazon requires it first be empty)
  $bucket->delete_bucket;

=head1 DESCRIPTION

This module represents an S3 bucket.  You get a bucket object
from the L<AnyEvent::Net::Amazon::S3> object.

This module provides the same interface as L<Net::Amazon::S3::Bucket>.
In addition, some asynchronous methods returning AnyEvent condition variable are added.

=head1 METHODS

All L<Net::Amazon::S3::Bucket> methods are available.
In addition, there are the following asynchronous methods.
Arguments of the methods are identical as original but return value becomes L<AnyEvent> condition variable.
You can get actual return value by calling C<shift-E<gt>recv()>.

=for :list
= add_key_async
= add_key_filename_async
= copy_key_async
= edit_metadata_async
= head_key_async
= get_key_async
= get_key_filename_async
= delete_key_async
= delete_bucket_async
= list_async
= list_all_async
= get_acl_async
= set_acl_async
= get_location_constraint_async

=begin Pod::Coverage

err
errstr

=end Pod::Coverage

=head1 SEE ALSO

=for :list
* L<AnyEvent::Net::Amazon::S3>
* L<Net::Amazon::S3> - Based on it as original.
* L<Module::AnyEvent::Helper> - Used by this module. There are some description for needs of _async methods.

