package YesBot;

use strict;
use warnings;
use utf8;
use base qw/BotBase/;
use experimental qw/signatures/;

my @responses = ("Да", "ДА", "ДА!!!", "ДА ДА ДА!!!");

sub handle_text_match($self, $json) {
  $self->reply_from_list($json, $json->{id}, \@responses);
}
