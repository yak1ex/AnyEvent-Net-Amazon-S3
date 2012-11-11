package AnyEvent::Net::Amazon::S3::Request::CreateBucket;

# ABSTRACT: An internal class to create a bucket
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

  my $http_request = AnyEvent::Net::Amazon::S3::Request::CreateBucket->new(
    s3                  => $s3,
    bucket              => $bucket,
    acl_short           => $acl_short,
    location_constraint => $location_constraint,
  )->http_request;

=head1 DESCRIPTION

This module is the same as L<Net::Amazon::S3::Request::CreateBucket>, except for its name.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

