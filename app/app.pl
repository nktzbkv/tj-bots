#!/usr/bin/env perl

use strict;
use warnings;
use Mojolicious::Lite -signatures;
use Bots;
use JSON::XS qw/decode_json/;
use Carp;
use Data::Dumper;
use File::Basename qw/dirname/;
use Cwd qw/realpath/;

$SIG{__DIE__} = \&Carp::confess;

my $config_path = $ENV{BOT_CONFIG} || realpath(dirname(__FILE__).'/../var/config/config.pl');
my $config = do($config_path) or  die "Failed to load config from $config_path";
my $bots = Bots->new(config => $config->{bots} || die "bots settings are missing in $config_path");

if (my $log_path = $config->{log_path} || $ENV{MOJO_LOG}) {
  my $log_level = $config->{log_level} || $ENV{MOJO_LOG_LEVEL} || 'warn';
  print STDERR "Setting logger to $log_path, level $log_level\n";
  my $log = Mojo::Log->new(path => $log_path, level => $log_level);
  $SIG{__WARN__} = sub { $log->warn(@_); };
  app->log($log);
}

app->config($config->{mojo} or die "mojo settings are missing in $config_path");
app->secrets($config->{mojo}{secrets}) if $config->{mojo}{secrets};

get '/' => sub ($c) {
  $c->render(json => '( ͡° ͜ʖ ͡°)');
};

post '/new-comment/:tag' => sub ($c) {
  my $body = $c->req->body or return $c->render(text => 'body is missing');
  my $tag = $c->param('tag') or return $c->render(text => 'tag is missing');

  $c->log->warn($@) unless eval { $bots->handle(decode_json($body), $tag); 1 };
  $c->render(text => '');
};

app->start;
