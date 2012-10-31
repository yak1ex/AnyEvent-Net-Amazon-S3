package AnyEvent::Net::Amazon::S3::Request::GetObject;

# ABSTRACT: An internal class to get an object

use strict;
use warnings;
use parent qw(Net::Amazon::S3::Request::GetObject);

1;
__END__
=pod

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::Request::GetObject->new(
    s3     => $s3,
    bucket => $bucket,
    key    => $key,
    method => 'GET',
  )->http_request;

=head1 DESCRIPTION

This module is just a dumb subclass of L<Net::Amazon::S3::Request::GetObject>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

=head2 query_string_authentication_uri

This method returns query string authentication URI.

=cut
