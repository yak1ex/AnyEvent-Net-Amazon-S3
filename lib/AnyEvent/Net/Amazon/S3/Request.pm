package AnyEvent::Net::Amazon::S3::Request;

# ABSTRACT: Base class for request objects

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__,
        -target => substr(__PACKAGE__, 10),
        -transformer => 'Net::Amazon::S3';

1;
__END__

=head1 SYNOPSIS

  # do not instantiate directly

=head1 DESCRIPTION

This module is a base class for all the Net::Amazon::S3::Request::*
classes in original Net::Amazon::S3 distribution.
In this distribution, however, it is just a placeholder.
