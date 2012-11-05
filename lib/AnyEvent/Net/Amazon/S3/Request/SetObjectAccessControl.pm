package AnyEvent::Net::Amazon::S3::Request::SetObjectAccessControl;

# ABSTRACT: An internal class to set an object's access control

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__,
        -target => substr(__PACKAGE__, 10),
        -transformer => 'Net::Amazon::S3';

1;
__END__

=head1 SYNOPSIS

  my $http_request = AnyEvent::Net::Amazon::S3::Request::SetObjectAccessControl->new(
    s3        => $s3,
    bucket    => $bucket,
    key       => $key,
    acl_short => $acl_short,
    acl_xml   => $acl_xml,
  )->http_request;

=head1 DESCRIPTION

This module is just a dumb subclass of L<Net::Amazon::S3::Request::SetObjectAccessControl>.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.
