package SixteenColors;

use Moose;
use namespace::autoclean;

use 5.10.0;
use Catalyst::Runtime '5.80';
use Catalyst qw(
    ConfigLoader
    Authentication
    FillInForm
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Unicode
    Static::Simple
);
use CatalystX::RoleApplicator;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->apply_request_class_roles( 'SixteenColors::Role::Request' );
__PACKAGE__->config(
    name                => 'SixteenColors',
    default_view        => 'HTML',
    'Plugin::Authentication' => {
        default_realm => 'openid',
        realms        => {
            openid => {
                class      => '+SixteenColors::Authentication::Realm::OpenID',
                credential => { class => 'OpenID', },
                store      => {
                    class         => 'DBIx::Class',
                    user_model    => 'DB::Account',
                    id_field      => 'id',
                    role_relation => 'roles',
                    role_field    => 'name',
                },
            },
        }
    },
);

# Start the application
__PACKAGE__->setup();

sub is_development_server {
    my $c = shift;
    return 1 if $c->debug || $c->request->uri->host =~ m{(localhost|beta)};
    return 0;
}

sub prepare_path {
    my $c = shift;
    $c->next::method( @_ );
    $c->request->original_uri( $c->request->uri->clone );

    my @path_parts = split m[/], $c->request->path, -1;

    # Feeds
    if( @path_parts && $path_parts[ -1 ] =~ m{\.feed$} ) {
        $path_parts[ -1 ] =~ s{\.feed$}{};
        my $path = join( '/', @path_parts ) || '/';
        $c->request->path( $path );
        
        $c->stash( current_view_instance => $c->view( 'Feed' ) );
    }

    return;
}

1;

__END__

=head1 NAME

SixteenColors - Search and browse artpacks from 1990 to present

=head1 SYNOPSIS

    script/sixteencolors_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 is_development_server

=head2 prepare_path

=head1 SEE ALSO

=over 4

=item * L<SixteenColors::Controller::Root>

=item * L<Catalyst>

=item * http://sixteencolors.net

=back

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
