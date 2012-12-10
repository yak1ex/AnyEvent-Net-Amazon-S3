package AnyEvent::Net::Amazon::S3::Request::CompleteMultipartUpload;

# ABSTRACT: An internal class to complete a multipart upload
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

  my $http_request = AnyEvent::Net::Amazon::S3::Request::CompleteMultipartUpload->new(
    s3                  => $s3,
    bucket              => $bucket,
    etags               => \@etags,
    part_numbers        => \@part_numbers,
  )->http_request;

=head1 DESCRIPTION

This module is the same as L<Net::Amazon::S3::Request::CompleteMultipartUpload>, except for its name.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
