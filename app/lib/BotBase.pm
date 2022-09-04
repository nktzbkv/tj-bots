package BotBase;

use strict;
use warnings;
use JSON::XS qw/encode_json/;
use experimental qw/signatures/;

sub new {
  my $proto = shift;
  my %object = @_;

  if (!$object{test}) {
    for (qw/api_url api_token/) {
      die "$_ required" unless $object{$_};
    }
  }

  return bless(\%object, ref($proto) || $proto);
}

sub attachment($self, $url, $cb) {
  if ($self->{test}) {
    warn("attachment ".encode_json($url));
    $cb->($url);
    return;
  }
}

sub comment($self, %params) {
  # my $image_url = delete $params{image_url};
  # return $self->attachment($image_url, sub($res) {
  #   $self->comment(%params, attachments => $res->{result});
  # }) if $image_url;;

  my $form = $self->make_api_form(\%params,
    [qw/id text/], [qw/reply_to attachments/]);

  if ($self->{test}) {
    warn("comment ".encode_json($form));
    return;
  }

  $self->mojo_ua->post(
    $self->{api_url}.'/comment/add',
    {'X-Device-Token' => $self->{api_token}},
    form => $form, sub ($ua, $tx) {
      my $res = $tx->result;
      warn "Failed to post comment: ".$res->message unless $res->is_success;
    });
}

sub like($self, %params) {
  if (my $delay = delete $params{delay}) {
    Mojo::IOLoop->timer((1 + rand($self->{reply_delay})) => sub {
      $self->like(%params);
    });
  } else {
    if ($self->{test}) {
      warn("like ".encode_json(\%params));
      return;
    }

    my $form = $self->make_api_form(\%params, [qw/id type sign/], []);

    $self->mojo_ua->post(
      $self->{api_url}.'/like',
      {'X-Device-Token' => $self->{api_token}},
      form => $form, sub ($ua, $tx) {
        my $res = $tx->result;
        warn "Failed to like: ".$res->message unless $res->is_success;
      });
  }
}

sub make_api_form($self, $params, $mandatory_fields, $optional_fields) {
  my %form;
  for (@$mandatory_fields) {
    die "$_ is missing" unless defined $params->{$_};
    $form{$_} = $params->{$_};
  }
  for (@$optional_fields) {
    $form{$_} = $params->{$_} if $params->{$_};
  }
  return \%form;
}

my $seed = int($ENV{BOT_SEED} || 0) || 13;

sub random_pick($self, $list, $id) {
  while (1) {
    return unless defined($list);
    last unless ref($list);

    if (ref($list) eq 'ARRAY') {
      return unless @$list;
      $list = $list->[rand @$list]
    } elsif (ref($list) eq 'CODE') {
      $list = $list->();
    } else {
      last;
    }
  }
  return $list;
}

sub reply_from_list($self, $json, $to, $list) {
  my $text = $self->random_pick($list, $json->{id});
  return unless defined $text;

  my %payload = (
    id => $json->{content}{id},
    reply_to => $to,
    ((ref($text) eq 'HASH') ? %$text : (text => $text)),
  );

  if ($self->{reply_delay}) {
    Mojo::IOLoop->timer((1 + rand($self->{reply_delay})) => sub {
      $self->comment(%payload);
    });
  } else {
    $self->comment(%payload);
  }
}


sub mojo_ua($self) {
  $self->{mojo_ua} ||= Mojo::UserAgent->new;
}

1;
