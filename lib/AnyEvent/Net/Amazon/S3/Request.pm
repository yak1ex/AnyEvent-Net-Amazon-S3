package AnyEvent::Net::Amazon::S3::Request;

# ABSTRACT: Base class for request objects

use strict;
use warnings;
use parent qw(Net::Amazon::S3::Request);

1;
__END__
=pod

=head1 SYNOPSIS

  # do not instantiate directly

=head1 DESCRIPTION

This module is a base class for all the Net::Amazon::S3::Request::*
classes in original Net::Amazon::S3 distribution.
In this distribution, however, it is just a placeholder.
