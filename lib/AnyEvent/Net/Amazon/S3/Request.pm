package AnyEvent::Net::Amazon::S3::Request;
use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use Net::Amazon::S3::Request;

# ABSTRACT: Base class for request objects

extends 'Net::Amazon::S3::Request';

has 's3' => ( is => 'ro', isa => 'AnyEvent::Net::Amazon::S3', required => 1 );

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 SYNOPSIS

  # do not instantiate directly

=head1 DESCRIPTION

This module is a base class for all the AnyEvent::Net::Amazon::S3::Request::*
classes.
