# Bots from tjournal.ru

This single project contains sources code for several bots:

1. Нейроорлов
2. Дон Бот
3. Порфирьевич
4. Нужен Ответ
5. Нейродыня
6. Нейротоксик

Other non-popular ones were removed.

To make this work, the following changes required:

1. Add proper HTTPD_HOST and TJOURNAL_WEBHOOK_TOKEN in GNUmakefile
2. Add proper api_token in protos/config.pl

Of course you need a proper tjournal.ru.

To start:

`make start`

To stop:

`make stop`

You also might need to install dependencies:

`make deps`

This code provided as is without any guarantee from developer's side.
