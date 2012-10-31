package AnyEvent::Net::Amazon::S3::Request::ListAllMyBuckets;

# ABSTRACT: An internal class to list all buckets

use strict;
use warnings;
use parent qw(Net::Amazon::S3::Request::ListAllMyBuckets);

1;
__END__
=pod

=head1 SYNOPSIS

  my $http_request
    = AnyEvent::Net::Amazon::S3::Request::ListAllMyBuckets->new( s3 => $s3 )
    ->http_request;

=head1 DESCRIPTION

This module is just a dumb subclass of L<Net::Amazon::S3::Request::ListAllMyBuckets>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

=cut
