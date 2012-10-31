package AnyEvent::Net::Amazon::S3::Client::Bucket;

# ABSTRACT: An easy-to-use Amazon S3 client bucket

use strict;
use warnings;

# TODO: Maybe, it is necessary to replace Net::Amazon::S3::Client::Object
# TODO: list()

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3::Client::Bucket',
	-translate_func => [qw(_create delete acl location_constraint)],
	-replace_func => [qw(_send_request _send_request_content _send_request_xpc)]
;

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  # return the bucket name
  print $bucket->name . "\n";

  # return the bucket location constraint
  print "Bucket is in the " . $bucket->location_constraint . "\n";

  # return the ACL XML
  my $acl = $bucket->acl;

  # list objects in the bucket
  # this returns a L<Data::Stream::Bulk> object which returns a
  # stream of L<AnyEvent::Net::Amazon::S3::Client::Object> objects, as it may
  # have to issue multiple API requests
  my $stream = $bucket->list;
  until ( $stream->is_done ) {
    foreach my $object ( $stream->items ) {
      ...
    }
  }

  # or list by a prefix
  my $prefix_stream = $bucket->list( { prefix => 'logs/' } );

  # returns a L<AnyEvent::Net::Amazon::S3::Client::Object>, which can then
  # be used to get or put
  my $object = $bucket->object( key => 'this is the key' );

  # delete the bucket (it must be empty)
  $bucket->delete;

=head1 DESCRIPTION

This module represents buckets.

=head1 METHODS

=head2 acl

  # return the ACL XML
  my $acl = $bucket->acl;

=head2 delete

  # delete the bucket (it must be empty)
  $bucket->delete;

=head2 list

  # list objects in the bucket
  # this returns a L<Data::Stream::Bulk> object which returns a
  # stream of L<AnyEvent::Net::Amazon::S3::Client::Object> objects, as it may
  # have to issue multiple API requests
  my $stream = $bucket->list;
  until ( $stream->is_done ) {
    foreach my $object ( $stream->items ) {
      ...
    }
  }

  # or list by a prefix
  my $prefix_stream = $bucket->list( { prefix => 'logs/' } );

=head2 location_constraint

  # return the bucket location constraint
  print "Bucket is in the " . $bucket->location_constraint . "\n";

=head2 name

  # return the bucket name
  print $bucket->name . "\n";

=head2 object

  # returns a L<AnyEvent::Net::Amazon::S3::Client::Object>, which can then
  # be used to get or put
  my $object = $bucket->object( key => 'this is the key' );

