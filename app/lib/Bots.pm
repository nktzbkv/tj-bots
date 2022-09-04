package Bots;

use strict;
use warnings;
use experimental qw/signatures/;

sub new($proto, %settings) {
  my $config = delete $settings{config};

  die "Expecting hash reference for bots conifg"
    unless $config && ref $config eq 'HASH';

  my %dispatch;
  for my $tag (keys %$config) {
    my $tag_config = $config->{$tag} or next;

    die "Expecting hash reference for tag config"
      unless ref $tag_config eq 'HASH';

    my %base = %$tag_config;
    my $list = delete $base{list};
    my $ignore_users = delete $base{ignore_users};

    my $tag_dispatch = ($dispatch{$tag} ||= {
      mention => {},
      reply => {},
      post_reply => {},
      victim_mention => {},
      victim_reply => {},
      ignore_users => {},
      text_match => [],
    });

    if ($ignore_users) {
      $tag_dispatch->{ignore_users}{$_} = 1 for @$ignore_users;
    }

    _load_bots($tag_dispatch, $list, \%base);
  }

  # warn _dumper(\%dispatch);

  return bless({
    dispatch => \%dispatch
  }, ref($proto) || $proto);
}

sub handle($self, $json, $tag) {
  return unless 'new_comment' eq ($json->{type} // '');
  my $data = $json->{data} or return;
  my $bots = $self->{dispatch}{$tag} or return;

  # ignore bot comments
  my $creator_id = $data->{creator}{id};
  return if $creator_id && $bots->{ignore_users}{$creator_id};

  if (my $rt = $data->{reply_to}) {
    return if _handle_user_id($bots->{reply}, $rt->{creator}{id}, handle_reply => $data);
  } elsif (my $c = $data->{content}) {
    return if _handle_user_id($bots->{post_reply}, $c->{owner}{id}, handle_post_reply => $data);
  }

  if (my $text = $data->{text}) {
    for ($text =~ /\[\@(\d+)\|/g) {
      return if _handle_user_id($bots->{mention}, $_, handle_mention => $data);
      return if _handle_user_id($bots->{victim_mention}, $_, handle_victim_mention => $data);
    }
    for (@{$bots->{text_match}}) {
      my ($t, $handler) = @$_;
      next unless $text =~ $t;
      $handler->handle_text_match($data);
      return;
    }
  }
}

sub _handle_user_id($bots, $uid, $method, $json) {
  return unless $uid;
  my $handler = $bots->{$uid} or return;
  $handler->$method($json);
  return 1;
}

sub _scalar_or_array($value) {
  return unless defined $value;
  if (my $r = ref($value)) {
    return map { _scalar_or_array($_) } @$value if $r eq 'ARRAY';
  }
  return $value;
}

sub _load_bots($tag_dispatch, $list, $base) {
  die "Expecting array reference for bots list"
    unless $list && ref $list eq 'ARRAY';

  for my $item (@$list) {
    die "Expecting hash reference for bot config but got "._dumper($item)
      unless $item && ref $item eq 'HASH';

    my %params = %$item;
    my $package = delete $params{class} or die "Bot config is missing class name: "._dump_config($item);
    eval("require $package;") or die $@;

    my $bot = $package->new(%params, %$base) or die "Failed to create instance of $package";

    if (my $user_id = $item->{user_id}) {
      $tag_dispatch->{ignore_users}{$user_id} = 1;
      $tag_dispatch->{mention}{$user_id} = $bot if $bot->can('handle_mention');
      $tag_dispatch->{reply}{$user_id} = $bot if $bot->can('handle_reply');
      $tag_dispatch->{post_reply}{$user_id} = $bot if $bot->can('handle_post_reply');
    }

    if ($bot->can('handle_text_match')) {
      for my $re (_scalar_or_array($item->{text_match})) {
        '1234567890abcdefghijklmnopqrtsuvw' =~ $re;
        push @{$tag_dispatch->{text_match}}, [$re, $bot];
      }
    }

    for my $vid (_scalar_or_array($item->{victim_user_id})) {
      if ($bot->can('handle_victim_mention')) {
        die "Duplicate victim_mention for $vid" if $tag_dispatch->{victim_mention}{$vid};
        $tag_dispatch->{victim_mention}{$vid} = $bot;
      }
      if ($bot->can('handle_victim_reply')) {
        die "Duplicate victim_reply for $vid" if $tag_dispatch->{victim_mention}{$vid};
        $tag_dispatch->{victim_reply}{$vid} = $bot;
      }
    }
  }
}

sub _dumper {
  return Data::Dumper->new(\@_)->Terse(1)->Sortkeys(1)->Dump;
}

sub _dump_config($value) {
  my %copy = %$value;
  for (qw/api_token/) {
    $copy{$_} = '****' if exists $copy{$_};
  }
  return _dumper(\%copy);
}

1;
