package AnyEvent::Net::Amazon::S3::Request::PutObject;

# ABSTRACT: An internal class to put an object

use strict;
use warnings;
use parent qw(Net::Amazon::S3::Request::PutObject);

1;
__END__
=pod

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::Request::PutObject->new(
    s3        => $s3,
    bucket    => $bucket,
    key       => $key,
    value     => $value,
    acl_short => $acl_short,
    headers   => $conf,
  )->http_request;

=head1 DESCRIPTION

This module is just a dumb subclass of L<Net::Amazon::S3::Request::PutObject>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

=cut
