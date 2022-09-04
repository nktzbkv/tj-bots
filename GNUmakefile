ROOT       ?= $(realpath .)
PERL       ?= $(shell which perl)
MAKE       ?= $(shell which make)

APP        ?= $(ROOT)/app
PROTOS     ?= $(APP)/protos
PUBLIC     ?= $(APP)/public
VAR        ?= $(ROOT)/var
CONFIG     ?= $(VAR)/config
LOGS       ?= $(VAR)/logs
PID_FILE   ?= $(VAR)/app.pid

HTTPD_HOST ?= example.com # domain of site for webhook
HTTPD_PORT ?= 8069
HTTPD_BIND ?= 127.0.0.1:$(HTTPD_PORT)

DEPLOY_HOST ?= www@$(HTTPD_HOST) # user@host for ssh deploy
DEPLOY_PATH ?= ~/sites/bots # path for ssh deploy

ENV_SETUP  ?= PERLLIB=$(APP)/lib

HYPNOTOAD_BIN ?= $(shell which hypnotoad)
START_HYPNOTOAD ?= MOJO_LOG=$(LOGS)/hypnotoad.log $(ENV_SETUP) $(HYPNOTOAD_BIN) $(APP)/app.pl

STARMAN_BIN ?= $(shell which starman)
START_STARMAN ?= MOJO_LOG=$(LOGS)/starman.log $(ENV_SETUP) PLACK_ENV=production starman -l "$(HTTPD_BIND)" -D --pid "$(PID_FILE)" --workers 5 --error-log "$(LOGS)/app-errors.log" --preload-app $(APP)/app.pl

START_COMMAND ?= $(START_HYPNOTOAD)
STOP_COMMAND ?= (test -f '$(VAR)/app.pid' && kill `cat $(VAR)/app.pid`) || true

TJOURNAL_WEBHOOK_TAG ?= c9fad753fc9c1199486f421a8226d0d4 # any unique string
TJOURNAL_WEBHOOK_TOKEN ?= *** 

DTF_WEBHOOK_TAG ?= d8342cdcc28dee2f863a4ba81c746ef6
DTF_WEBHOOK_TOKEN ?= ***

-include $(ROOT)/local.mk

build-protos: make-dirs
	$(call build,$(PROTOS)/config.pl,$(CONFIG)/config.pl)
	$(call build,$(PROTOS)/nginx.conf,$(CONFIG)/nginx.conf)
	$(call build,$(PROTOS)/start.sh,$(CONFIG)/start.sh)
	$(call build,$(PROTOS)/stop.sh,$(CONFIG)/stop.sh)
	$(call build,$(PROTOS)/healthcheck.sh,$(CONFIG)/healthcheck.sh)
	$(call build,$(PROTOS)/crontab,$(CONFIG)/crontab)

make-dirs:
	@mkdir -p "$(VAR)"
	@mkdir -p "$(CONFIG)"
	@mkdir -p "$(LOGS)"

update:
	git pull

deps:
	cpanm --installdeps $(APP)

dbshell:
	sqlite3 $(VAR)/db

deploy:
	$(MAKE) update
	$(MAKE) start

remote-deploy:
	ssh $(DEPLOY_HOST) 'make -C "$(DEPLOY_PATH)" deploy'

git-push:
	git add .
	git commit -a -m "..."
	git push origin HEAD

push-deploy: git-push remote-deploy

start-dev: build-protos
	$(ENV_SETUP) morbo -l "http://$(HTTPD_BIND)" $(APP)/app.pl

start-hypnotoad: build-protos
	$(STOP_COMMAND)
	$(START_HYPNOTOAD)

start-starman: build-protos
	$(STOP_COMMAND)
	$(START_STARMAN)

start: build-protos
	/bin/bash $(CONFIG)/start.sh

stop: build-protos
	$(STOP_COMMAND)

stop-full:
	/bin/bash $(CONFIG)/stop.sh

export

define build
	$(PERL) -e 'for (<STDIN>) {s/@(\S+?)@/$$ENV{$$1}/ge; print;}' < $(1) > $(2)
endef
