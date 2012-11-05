package Module::AnyEvent::Helper::PPI::Transform::Net::Amazon::S3;

use strict;
use warnings;

use parent qw(PPI::Transform::PackageName);

sub new
{
    my ($self) = @_;
    my $ret = $self->SUPER::new(
        -all => sub {
print STDERR "BEFORE: $_ ";
            s/^Net::Amazon::S3\b/AnyEvent::Net::Amazon::S3/g;
            s/^LWP::UserAgent\b/AnyEvent::HTTP::LWP::UserAgent/g;
print STDERR "AFTER: $_ ";
        }
    );
    return $ret;
}

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION
