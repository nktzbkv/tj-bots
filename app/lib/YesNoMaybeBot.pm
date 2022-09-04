package YesNoMaybeBot;

use strict;
use warnings;
use utf8;
use base qw/BotBase/;
use experimental qw/signatures/;

my @responses = (
  ['Ага', 'Да', 'ДА!!!', 'Скорее да', 'Точно да', 'Конечно да', 'Конечно', 'Естественно', 'Естественно да'],
  ['Нет', 'Неа', 'Скорее нет', 'Точно нет', 'Конечно нет', 'Естественно нет'],
  ['Возможно', 'Скорее всего', 'Маловероятно'],
  ['50/50', 'Фифти фифти', 'Зависит от точки зрения'],
);

sub handle_mention($self, $json) {
  $self->reply_from_list($json, $json->{id}, \@responses);
}

sub handle_text_match($self, $json) {
  $self->reply_from_list($json, $json->{id}, \@responses);
}

1;
