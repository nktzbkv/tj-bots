package WhoIsBot;

use strict;
use warnings;
use utf8;
use JSON::XS qw/encode_json/;
use base qw/BotBase/;
use experimental qw/signatures/;

sub handle_victim_mention($self, $json) {
  $self->handle_all($json);
}

sub handle_text_match($self, $json) {
  $self->handle_all($json);
}

sub handle_all($self, $json) {
  $self->handle_creator($json, $json->{reply_to}{creator} || $json->{content}{creator});
}

my %skip_users = map {$_ => 1} qw/179385 303671 446210/;

sub handle_creator($self, $json, $creator) {
  return unless $creator;

  my $id = $creator->{id} or return;
  my $name = $creator->{name};

  if ($skip_users{$id}) {
    $self->comment(
      id => $json->{content}{id},
      reply_to => $json->{id},
      text => "Я не знаю других имен «$name»"
    );
  } else {
    my $body = encode_json([$id]);

    _cacher_request($self->{retries} || 2, $self->mojo_ua, $body, sub ($res) {
      return unless $res && $res->{$id};

      my @names = @{$res->{$id}};
      @names = grep { $_ ne $name } @names if defined $name;

      if (@names) {
        my $prefix = defined($name) ? "«$name» еще известен как" : "Еще известен как";
        my $text = $prefix." ".join(", " => map {"«$_»"} @names);
        # my $text = (@names == 1) ? ($prefix." ".$names[0]) : ($prefix.":".join('' => map { "\n* $_"} sort @names));
        $self->comment(
          id => $json->{content}{id},
          reply_to => $json->{id},
          text => $text
        );
      } elsif (defined $name) {
        $self->comment(
          id => $json->{content}{id},
          reply_to => $json->{id},
          text => "Я не знаю других имен «$name»"
        );
      }
    });
  }
}

sub _cacher_request($retries, $ua, $body, $callback) {
  $ua->post(
    'https://names-cacher.serguun42.ru/tjournal',
    {
      'Origin' => 'https://tjournal.ru',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1 Safari/605.1.15',
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
    }, $body, sub ($ua, $tx) {
      my $res = $tx->result;
      if ($res->is_success) {
        $callback->($res->json);
      } elsif ($retries > 0) {
        # warn Bots::_dumper($res);
        _cacher_request($retries - 1, $ua, $body, $callback);
      } else {
        $callback->(undef);
      }
    });
}

1;
