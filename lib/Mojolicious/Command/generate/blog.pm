package Mojolicious::Command::generate::blog;

our $VERSION = '0.005'; # VERSION

use strictures 1;
use Mojo::Base "Mojolicious::Command";
use Mojo::Util qw(class_to_path class_to_file);
use IO::Prompt;
use Data::Dump qw(pp);

has description => "Generate a Mojolcious Blog and its Database properties";
has usage => "usage: $0 generate blog [NAME]";

sub run {
    my $self  = shift;
    my $class = shift;

    my $name = class_to_file $class;
    my $app  = class_to_path $class;

    my $dbtype = prompt "Which database type should I use?", -1,
      -menu => ['NoSQL', 'Relational Database',];
    my $title =
      (prompt -tty, "Set your blog title: ", -default => "Mojomomo Blog");

    my $slogan = (prompt -tty, "Set slogan: ", -default => "A blog");
    my $author = (prompt -tty, "Author: ",     -default => $ENV{USER});
    my $email = (prompt -tty, "Email: ", -default => 'user@example.com');
    say "I've got everything I need, preparing your "
      . "blog $title with a $dbtype backend";

    $self->render_to_rel_file('script', "$name/script/$name",
        $dbtype, $title, $slogan, $author, $email);
    $self->chmod_file("$name/script/$name", 0744);
}

1;

__DATA__

@@ script
% my $dbtype = shift;
% my $title  = shift;
% my $slogan = shift;
% my $author = shift;
% my $email  = shift;
#!/usr/bin/env perl
 
use strictures 1;
use Mojolicious::Lite;

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

# Mojolicious::Lite
plugin 'Blog' => {
    authCondition => $conditions,
    title         => <%= $title %>,
    slogan        => <%= $slogan %>,
    contact       => <%= $email %>,
    author        => <%= $author %>,
    dsn           => "dbi:SQLite:dbname=db/myblog.db",
};

__END__

=head1 NAME

Mojolicious::Command::generate::blog - Blog generator for Mojolicious

=head1 DESCRIPTION

Helper to generate database connection and other config settings

=cut
