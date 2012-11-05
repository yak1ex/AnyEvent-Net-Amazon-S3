package AnyEvent::Net::Amazon::S3::Request::GetObjectAccessControl;

# ABSTRACT: An internal class to get an object's access control

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__,
        -target => substr(__PACKAGE__, 10),
        -transformer => 'Net::Amazon::S3';

1;
__END__

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::Request::GetObjectAccessControl->new(
    s3     => $s3,
    bucket => $bucket,
    key    => $key,
  )->http_request;

=head1 DESCRIPTION

This module is just a dumb subclass of L<Net::Amazon::S3::Request::GetObjectAccessControl>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
