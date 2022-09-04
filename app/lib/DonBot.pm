package DonBot;

use strict;
use warnings;
use utf8;
use base qw/BotBase/;
use experimental qw/signatures/;

my @replies = (
  ["Извинись", "Извинись ДОН"],
  "Сейчас будешь извиняться",
  "Проси прощения",
  "Плохо извиняешься",
  "Не вижу искренних извинений",
  "Не чувствую раскаяния",
  "Придется тебе встать на колени",
  # "Ищи себя в прошмандовках Грозного",
  "Говори свой адрес",
  "Мои ребята уже выехали к тебе",
  "Мои ребята ДОН уже выехали к тебе",
  "Эрон ДОН ДОН",
  "Извинись пока Аллах милостив",
  # "Ладно, в честь Нового Года прощаю",
);

sub handle_mention($self, $json) {
  my ($text, $reply_to) = _parse_request($json->{text}, $json->{id});

  if (!defined $text) {
    ($text, $reply_to) = $json->{reply_to}
      ? _parse_request($json->{reply_to}{text}, $json->{reply_to}{id})
      : _parse_request($json->{content}{title}, undef);
    return unless defined $text;
  }

  my $repeat = int(2.5 + rand 5);
  my $counter = 0;
  # $text =~ s/(\W*\s+)/((++$counter) % $repeat) ? $1 : $1.'ДОН '/ge;
  # $text .= ' ДОН' if $counter < $repeat;
  $text .= ' ДОН' unless $text =~ s/([.,;:!?]+)/ ДОН$1/g;

  $self->comment(
    id => $json->{content}{id},
    reply_to => $reply_to,
    text => $text);
}

sub handle_text_match($self, $json) {
  $self->handle_mention($json);
}

sub handle_reply($self, $json) {
  $self->reply_from_list($json, $json->{id}, \@replies);
}

sub _parse_request($text, $reply_to) {
  return unless defined $text;
  $text =~ s/\s*\[\@(\d+)\|.*?\]\s*//g;
  $text =~ s/\s*\@д+о+н+\s*б+о+т+\b//gi;
  return unless $text =~ /\S/;
  return ($text, $reply_to);
}

1;
