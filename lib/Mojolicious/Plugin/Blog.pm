package Mojolicious::Plugin::Blog;

use strictures 1;
use Mojo::Base 'Mojolicious::Plugin';
use File::Basename 'dirname';
use File::Spec::Functions 'catdir';
use DBIx::ResultSet;

use Mojolicious::Plugin::Blog::Controller;

our $VERSION = '0.002'; # VERSION

my %defaults = (

    # Basic options
    title   => 'Mojomomo Blog Plugin',
    slogan  => 'Im a really neat gorilla',
    author  => 'me-n-u',
    contact => 'momo\@example.com',
    tz      => 'America/New_York',

    # Social Integration options
    social => {
        github    => 'battlemidget',
        coderwall => 'battlemidget',
        twitter   => 'ajscg',
    },

    # DBIx::Connector supported Database Credentials
    dsn    => undef,
    dbuser => undef,
    dbpass => undef,
    dbconn => undef,
    dbrs   => undef,

    # Default routes
    indexPath       => '/blog/index',
    archivePath     => '/blog/archives',
    postPath        => '/blog/:id',
    adminPathPrefix => '/admin',

    # Router namespace
    namespace => 'Mojolicious::Plugin::Blog::Controller',

    # Set this to the under route for blog administration
    authCondition => undef,

    # TODO: Use json if you wish to provide custom templates.
    # renderType => undef,
);

sub register {
    my ($self, $app) = @_;
    my (%conf) = (%defaults, %{$_[2] || {}});

    my $base = catdir(dirname(__FILE__), 'BlogAssets');
    push @{$app->renderer->paths}, catdir($base, 'templates');
    push @{$app->static->paths},   catdir($base, 'public');

    push @{$app->renderer->classes}, __PACKAGE__;
    push @{$app->static->classes},   __PACKAGE__;

    $app->helper(blogconf => sub { \%conf });

    # Connect to our trusty database
    $app->blogconf->{dbconn} = DBIx::ResultSet->connect(
        $app->blogconf->{dsn},
        $app->blogconf->{dbuser},
        $app->blogconf->{dbpass},
    );
    $app->blogconf->{dbrs} = $app->blogconf->{dbconn}->resultset('posts');

    $app->routes->route($conf{indexPath})->via('GET')->to(
        namespace  => $conf{namespace},
        action     => 'blog_index',
        _blog_conf => \%conf,
    );

    $app->routes->route($conf{archivePath})->via('GET')->to(
        namespace  => $conf{namespace},
        action     => 'blog_archive',
        _blog_conf => \%conf,
    );

    $app->routes->route($conf{postPath})->via('GET')->to(
        namespace  => $conf{namespace},
        action     => 'blog_detail',
        _blog_conf => \%conf,
    );

    my $auth_r = $app->routes->under($conf{authCondition}->{authenticated});
    if ($auth_r) {
        $auth_r->route($conf{adminPathPrefix} . "/blog/new")->via('GET')->to(
            namespace  => $conf{namespace},
            action     => 'admin_blog_new',
            _blog_conf => \%conf,
        );
        $auth_r->route($conf{adminPathPrefix} . "/blog/edit/:id")->via('GET')
          ->to(
            namespace  => $conf{namespace},
            action     => 'admin_blog_edit',
            _blog_conf => \%conf,
          );
        $auth_r->route($conf{adminPathPrefix} . "/blog/update/:id")
          ->via('POST')->to(
            namespace  => $conf{namespace},
            action     => 'admin_blog_update',
            _blog_conf => \%conf,
          );
        $auth_r->route($conf{adminPathPrefix} . "/blog/delete/:id")
          ->via('GET')->to(
            namespace  => $conf{namespace},
            action     => 'admin_blog_delete',
            _blog_conf => \%conf,
          );
    }
    return;
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::Blog - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious

  # Set authentication condition
  my $conditions = {
    authenticated => sub {
        my $self = shift;
        unless ($self->session('authenticated')) {
            $self->flash(
                class   => 'alert alert-info',
                message => 'Please log in first!'
            );
            $self->redirect_to('/login');
            return;
        }
        return 1;
    },
  };

  $self->plugin('Blog' => {
      authCondition => $conditions
      dsn => "dbi:Pg:dbname=myblog",
      dbuser => 'zef',
      dbpass => 'letmein',
    }
  );

  # Mojolicious::Lite
  plugin 'Blog' => {
    authCondition => $conditions,
    dsn => "dbi:Pg:dbname=myblog",
    dbuser => 'zef',
    dbpass => 'letmein',
  };

=head1 DESCRIPTION

L<Mojolicious::Plugin::Blog> is a L<Mojolicious> plugin. The database layer is using L<DBIx::ResultSet> so
support for most databases is available. The examples in this distribution utilize Postgres.

=head1 OPTIONS

The blog options provide the gateway into defining your routes,
database connection, authentication conditions, blog title, slogan,
and more.

=head2 C<title>

Your blog title.

=head2 C<slogan>

Blog slogan.

=head2 C<author>

Who are you?

=head2 C<contact>

Your email

=head2 C<tz>

What timezone are you? e.g. 'America/New_York' for EST.

=head2 C<social>

Not implemented yet. However, support for integrating github, coderwall,
twitter, and others coming soon.

    # Social Integration options
    social => {
        github    => 'battlemidget',
        coderwall => 'battlemidget',
        twitter   => 'ajscg',
    },

=head2 C<dsn>

Database URI

=head2 C<dbuser>

Database User

=head2 C<dbpass>

Database password

=head2 C<dbconn>

Database connection, doesn't need to be manually set.

=head2 C<dbrs>

Database Resultset, again doesn't need to be set unless you
implement your own database layer.

=head2 C<indexPath>

Blog index route

=head2 C<archivePath>

Blog archive path

=head2 C<postPath>

Blog detail post path

=head2 C<adminPathPrefix>

Blog admin prefix route

=head2 C<namespace>

Blog controller namespace.

=head2 C<authCondition>

Router bridge for authencating the blog admin section. See the SYNOPSIS for example.

=head2 C<renderType>

Not Implemented, however the thought behind this was to allow return JSON in case
someone wanted to override existing templates.

=head1 METHODS

L<Mojolicious::Plugin::Blog> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 WHAT WORKS

Examples are include to show a work copy of the blog plugin for
viewing all blog posts and by detail.

=head1 TODO

Complete Administration section for adding/deleting/updating.

=head1 GOALS

Hopefully make this as database agnostic as possible and the overall
plugin a useful starting point for those wishing to implement a blog in
Mojolicious.

=head1 PATCHES

I love patches and community involvement, so please get involved and submit
pull requests and issues at

L<https://github.com/battlemidget/Mojolicious-Plugin-Blog>

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=head1 COPYRIGHT AND LICENSE

This plugin is copyright (c) 2013 by Adam Stokes <adamjs@cpan.org>

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

L<Mojolicious> is copyright (c) 2013 Sebastian Riedel <sri@cpan.org>

=cut
