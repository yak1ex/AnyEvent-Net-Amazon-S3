package AnyEvent::Net::Amazon::S3::Request::CreateBucket;

# ABSTRACT: An internal class to create a bucket

use strict;
use warnings;
use parent qw(Net::Amazon::S3::Request::CreateBucket);

1;
__END__
=pod

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::Request::CreateBucket->new(
    s3                  => $s3,
    bucket              => $bucket,
    acl_short           => $acl_short,
    location_constraint => $location_constraint,
  )->http_request;

=head1 DESCRIPTION

Just a dumb subclass of L<Net::Amazon::S3::Request::CreateBucket>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

=cut

