package BalabobaBot;

use strict;
use warnings;
use utf8;
use JSON::XS qw/encode_json/;
use base qw/BotBase/;
use experimental qw/signatures/;

sub handle_mention($self, $json) {
  my $content_id = $json->{content}{id};
  my $comment_id = $json->{id};

  my ($text, $reply_to) = _parse_request($json->{text}, $json->{id});

  if (!defined $text) {
    ($text, $reply_to) = $json->{reply_to}
      ? _parse_request($json->{reply_to}{text}, $json->{reply_to}{id})
      : _parse_request($json->{content}{title}, undef);

    return $self->comment(
      id => $content_id,
      reply_to => $comment_id,
      text => "Нужен текст",
    ) unless defined $text;
  }

  $self->generate($text, sub ($message) {
    if (defined $message) {
      return $self->comment(
        id => $content_id,
        reply_to => $reply_to,
        text => $message,
      );
    } else {
      return $self->comment(
        id => $content_id,
        reply_to => $comment_id,
        text => 'Что-то пошло не так ¯\_(ツ)_/¯',
      );
    }
  });
}

sub handle_text_match($self, $json) {
  $self->handle_mention($json);
}

sub generate($self, $text, $callback) {
  return $callback->(undef) unless defined $text;

  my $body = encode_json({query => $text, intro => 0, filter => 1});
  # warn encode_json($body);

  _balaboba_request($self->{retries} || 1, $self->mojo_ua, $body, sub ($json) {
    my $suffix = $json ? $json->{text} : undef;
    my $output = $suffix ? $text."\n".$suffix : undef;
    $callback->($output);
  });
}

sub _parse_request($text, $reply_to) {
  return unless defined $text;
  $text =~ s/\s*\[\@(\d+)\|.*?\]\s*//g;
  $text =~ s/\s*\@б+а+л+а+б+о+б+а+\b\s*//gi;
  return unless $text =~ /\S/;
  return ($text, $reply_to);
}

sub _balaboba_request($retries, $ua, $body, $callback) {
  $ua->post(
    'https://zeapi.yandex.net/lab/api/yalm/text3',
    {
      'Origin' => 'https://yandex.ru/',
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
    }, $body, sub ($ua, $tx) {
      my $res = $tx->result;
      if ($res->is_success) {
        $callback->($res->json);
      } elsif ($retries > 0) {
        # warn Bots::_dumper($res);
        _balaboba_request($retries - 1, $ua, $body, $callback);
      } else {
        $callback->(undef);
      }
    });
}

1;
