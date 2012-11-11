package Module::AnyEvent::Helper::PPI::Transform::Net::Amazon::S3;

# ABSTRACT: Additional transformer for Module::AnyEvent::Helper
# VERSION

use strict;
use warnings;

use parent qw(PPI::Transform::PackageName);

sub new
{
    my ($self) = @_;
    my $ret = $self->SUPER::new(
        -all => sub {
            s/^Net::Amazon::S3\b/AnyEvent::Net::Amazon::S3/g;
            s/^LWP::UserAgent\b/AnyEvent::HTTP::LWP::UserAgent/g;
            s/^Data::Stream::Bulk::Callback\b/Data::Stream::Bulk::AnyEvent/g;
        }
    );
    return $ret;
}

1;
__END__

=head1 SYNOPSIS

  use Module::AnyEvent::Helper::Filter -transformer => 'Net::Amazon::S3', -target => 'Net::Amazon::S3';

=head1 DESCRIPTION

This class is not intended to use directly.
