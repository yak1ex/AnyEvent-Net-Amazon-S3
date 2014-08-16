package Module::AnyEvent::Helper::PPI::Transform::Net::Amazon::S3::Client::Object;

# ABSTRACT: Additional transformer for Module::AnyEvent::Helper
# VERSION

use strict;
use warnings;

use parent qw(Module::AnyEvent::Helper::PPI::Transform::Net::Amazon::S3);

use Data::Dumper;
my $arrayref = PPI::Document->new(\'[]');

sub _is_enum_decl
{
    return $_[0]->isa('PPI::Statement') &&
        $_[0]->schild(0) && $_[0]->schild(0)->isa('PPI::Token::Word') && $_[0]->schild(0)->content eq 'enum';
}

sub _is_bare_qw
{
    my $qw = $_[0]->find_first('PPI::Token::QuoteLike::Words');
    return _is_enum_decl($qw->parent) ? $qw : undef;
}

sub document
{
    my ($self, $doc) = @_;
    $self->SUPER::document($doc);
    my $enum = $doc->find(sub { _is_enum_decl($_[1]) });
    foreach my $target (@$enum) {
        my $qw = _is_bare_qw($target);
        next unless $qw;
        my $next = $qw->snext_sibling;
        $qw->remove;
        my $ctor = $arrayref->child(0)->child(0)->clone;
        $ctor->add_element($qw);
        $next->insert_before($ctor);
    }
}

1;
__END__

=head1 SYNOPSIS

  use Module::AnyEvent::Helper::Filter -transformer => 'Net::Amazon::S3::Client::Object', -target => 'Net::Amazon::S3::Client::Object';

=head1 DESCRIPTION

This class is not intended to use directly.

It is to fix https://github.com/pfig/net-amazon-s3/pull/42 in Net::Amazon::S3 0.60.
