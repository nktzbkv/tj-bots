package ToxicBotDTF;

use strict;
use warnings;
use utf8;
use base qw/BotBase/;
use experimental qw/signatures/;

my @responses = (
  'Дохуя умный?',
  'Охуеть он умный',
  'Представься, мразь',
  'Не пизди',
  'Ава говно (субъективно)',
  'Твоя мать хорошая женщина',
  'Ух сука со смыслом (нет)',
  'Ты блять кто такой?',
  'А теперь сам прочитай что написал',
  'Ну и говно же у тебя в голове',
  'Все было хорошо пока ты не начал комментить',
  'Пиздец. Пишешь словно тебе 7 лет',
  'Пиздец и кто-то же подобное лайкает',
  'Ты опять выходишь на связь?',
  'Это все что смогли родить твои два с половиной нейрона?',
  'Сколько нужно твоих копий чтобы написать внятный текст?',
  'Лучше бы ты с мужиком поебался, а не вот это все',
  'Иди в хуй',
  'Охуеть. Что бы мы без тебя делали',
  'Твои сообщения это пранк вышедший из под контроля',
  'Ну и где так учат мысли выражать?',
  'Ты гей?',
  'Не рвись',
  'Началось. Сейчас опять душнить будешь?',
  'Сам читай свой высер',
  'Влепил бы диз тебе, но я птичка, мне это сложно',
  'Дед, пей таблетки, а то по жопе получишь',
  'Я с тобой не разговариваю',
  ['Не смешно', 'Это очень смешно', 'Смешно (нет)', 'Ахахах, это очень смешно (нет)'],
  'Рот закрой',
  'Как же деградировал DTF',
  'Чей Крым?',
  'Как правильно: на Украину или в Украину?',
  '( ͡° ͜ʖ ͡°)',
  'Тебя забыли спросить',
  'Ты бредишь?',
  'Это самое тупое что я читал сегодня',
  'Ой, все',
  'Ты русский?',
  'Тебе сколько лет?',
  'Как же ты слаб в постиронии',
  'Это тебя ебать не должно',
  'Закрой вкладку с сайтом и больше не возвращайся!',
  'Ты еврей?',
  '🤡🤡🤡',
  'Опять ты влез своей жопой не по делу',
  'А тебе обязательно сейчас надо было написать эту хуйню?',
  'Нечего сказать - не спамь',
);

sub handle_mention($self, $json) {
  my $to = $json->{reply_to} ? $json->{reply_to}{id} : undef;
  $self->reply_from_list($json, $to, \@responses);
}

sub handle_reply($self, $json) {
  my $text = $json->{text};
  $self->reply_from_list($json, $json->{id}, \@responses);
}

1;
