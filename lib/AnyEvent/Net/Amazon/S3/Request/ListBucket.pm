package AnyEvent::Net::Amazon::S3::Request::ListBucket;

# ABSTRACT: An internal class to list a bucket

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__,
        -target => substr(__PACKAGE__, 10),
        -transformer => 'Net::Amazon::S3';

1;
__END__

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::Request::ListBucket->new(
    s3        => $s3,
    bucket    => $bucket,
    delimiter => $delimiter,
    max_keys  => $max_keys,
    marker    => $marker,
  )->http_request;

=head1 DESCRIPTION

This module is just a dumb subclass of L<Net::Amazon::S3::Request::ListBucket>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
