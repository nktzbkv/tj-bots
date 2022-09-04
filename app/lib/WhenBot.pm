package WhenBot;

use strict;
use warnings;
use utf8;
use base qw/BotBase/;
use experimental qw/signatures/;

my @responses = (
  "Никогда",
  "Скоро",
  "Нужно потерпеть",
  "Придется потерпеть",
  "Нескоро",
  "Быстрее, чем ты думаешь",
  "В отдаленном будущем",
  "Завтра",
  "Сегодня",
  "Послезавтра",
  "Через месяц",
  "В понедельник",
  "Во вторник",
  "В среду",
  "В четверг",
  "В пятницу",
  "В субботу",
  "В воскресенье",
  "В полночь",
  "Когда выйдет Навальный",
  "Когда уйдет Путин",
);

sub handle_text_match($self, $json) {
  $self->reply_from_list($json, $json->{id}, \@responses);
}
