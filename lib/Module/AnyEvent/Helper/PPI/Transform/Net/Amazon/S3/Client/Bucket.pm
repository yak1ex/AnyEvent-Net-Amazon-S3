package Module::AnyEvent::Helper::PPI::Transform::Net::Amazon::S3::Client::Bucket;

# ABSTRACT: Additional transformer for Module::AnyEvent::Helper
# VERSION

use strict;
use warnings;

use parent qw(Module::AnyEvent::Helper::PPI::Transform::Net::Amazon::S3);

use Module::AnyEvent::Helper::PPI::Transform qw(is_function_declaration copy_children emit_cv replace_as_async);

my $list_def = PPI::Document->new(\'sub list { return shift->list_async(@_); }');
my $return_undef = PPI::Document->new(\'if($end) { $___cv___->send; return $___cv___; }');

sub document
{
    my ($self, $doc) = @_;
    $self->SUPER::document($doc);

# Find target
    my $list_decl = $doc->find_first(sub {
        $_[1]->isa('PPI::Token::Word') && is_function_declaration($_[1]) && $_[1]->content eq 'list';
    });
    my $sub_block = $list_decl->snext_sibling->find_first(sub {
        $_[1]->isa('PPI::Token::Word') && $_[1]->content eq 'sub';
    })->snext_sibling;

# sub block transformation
    my $target = $sub_block->find_first(sub {
        $_[1]->isa('PPI::Token::Word') && $_[1]->content eq '_send_request_xpc';
    });
    replace_as_async($target, '_send_request_xpc_async', 0);
    emit_cv($sub_block);
    $list_decl->set_content('list_async');
    my $target2 = $sub_block->find_first(sub {
        $_[1]->isa('PPI::Token::Symbol') && $_[1]->content eq '$end';
    });
    copy_children(undef, $target2->statement->snext_sibling, $return_undef);
    $target2->statement->delete;

# Add list() definition
    copy_children($list_decl->statement, undef, $list_def);
}

1;
__END__

=head1 SYNOPSIS

  use Module::AnyEvent::Helper::Filter -transformer => 'Net::Amazon::S3::Client::Bucket', -target => 'Net::Amazon::S3::Client::Bucket';

=head1 DESCRIPTION

This class is not intended to use directly.
