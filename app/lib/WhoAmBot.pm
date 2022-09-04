package WhoAmBot;

use strict;
use warnings;
use utf8;
use base qw/WhoIsBot/;
use experimental qw/signatures/;

sub handle_all($self, $json) {
  $self->handle_creator($json, $json->{creator});
}

1;
