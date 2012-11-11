package AnyEvent::Net::Amazon::S3::HTTPRequest;

# ABSTRACT: Create a signed HTTP::Request
# VERSION

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__,
        -target => substr(__PACKAGE__, 10),
        -transformer => 'Net::Amazon::S3';

1;
__END__

=for test_synopsis
no strict 'vars';

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
appropriately for Amazon S3,
and the same as L<Net::Amazon::S3::HTTPRequest>,
except for its name.

=method http_request

This method creates, signs and returns a HTTP::Request object.

=method query_string_authentication_uri

This method creates, signs and returns a query string authentication
URI.
