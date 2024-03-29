
use strict;
use warnings;

use 5.016000;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "Mojolicious plugin for blog integration",
  "AUTHOR" => "Adam Stokes <hackr\@cypherbook.com>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "Mojolicious-Plugin-Blog",
  "EXE_FILES" => [
    "bin/mojo-blog-db"
  ],
  "LICENSE" => "perl",
  "NAME" => "Mojolicious::Plugin::Blog",
  "PREREQ_PM" => {
    "DBIx::ResultSet" => 0,
    "Data::Dump" => 0,
    "File::Basename" => 0,
    "File::ShareDir" => 0,
    "File::Spec::Functions" => 0,
    "IO::Prompt" => 0,
    "Mojo::Base" => 0,
    "Mojo::Util" => 0,
    "Path::Tiny" => 0,
    "strictures" => 1
  },
  "TEST_REQUIRES" => {
    "Mojolicious::Lite" => 0,
    "Test::Mojo" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.005",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}


