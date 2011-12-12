package SixteenColors::Controller::Year;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    my $packs = $c->model( 'DB::Pack' );
    my $years = [ $packs->get_column( 'year' )->func( 'DISTINCT' ) ];

    $c->stash( title => 'Years', years => $years );
    
}

sub view : Path : Args(1) {
    my ( $self, $c, $year ) = @_;

    my $packs = $c->model( 'DB::Pack' )->search( { year => $year } );
    $c->stash( title => $year, packs => $packs );
}

1;

__END__

=head1 NAME

SixteenColors::Controller::Year - Catalyst Controller

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

=head2 view

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
