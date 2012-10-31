package AnyEvent::Net::Amazon::S3::HTTPRequest;

# ABSTRACT: Create a signed HTTP::Request

use strict;
use warnings;
use parent qw(Net::Amazon::S3::HTTPRequest);

1;
__END__
=pod

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::HTTPRequest->new(
    s3      => $self->s3,
    method  => 'PUT',
    path    => $self->bucket . '/',
    headers => $headers,
    content => $content,
  )->http_request;

=head1 DESCRIPTION

This module creates an HTTP::Request object that is signed
appropriately for Amazon S3, which is just a dumb subclass of
L<Net::Amazon::S3::HTTPRequest>.

=head1 METHODS

=head2 http_request

This method creates, signs and returns a HTTP::Request object.

=head2 query_string_authentication_uri

This method creates, signs and returns a query string authentication
URI.
