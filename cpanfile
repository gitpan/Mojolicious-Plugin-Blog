requires "DBIx::ResultSet" => "0";
requires "Data::Dump" => "0";
requires "File::Basename" => "0";
requires "File::ShareDir" => "0";
requires "File::Spec::Functions" => "0";
requires "IO::Prompt" => "0";
requires "Mojo::Base" => "0";
requires "Mojo::Util" => "0";
requires "Path::Tiny" => "0";
requires "perl" => "v5.16.0";
requires "strictures" => "1";

on 'test' => sub {
  requires "Mojolicious::Lite" => "0";
  requires "Test::Mojo" => "0";
  requires "Test::More" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
  requires "File::ShareDir::Install" => "0.03";
};
