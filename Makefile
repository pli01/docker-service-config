project ?=
env ?= # dev
sudo ?= # sudo -E

compose_args += -f docker-compose.yml
compose_args += $(shell [ -f  docker-compose.$(env).yml ] && echo "-f docker-compose.$(env).yml")

.PHONY: clean-image
all: stop rm up
clean:
	$(sudo) docker system prune -f
config:
	$(sudo) docker-compose $(compose_args) config

build: config
	$(sudo) docker-compose $(compose_args) build
pull:
	$(sudo) docker-compose $(compose_args) pull
up:
	$(sudo) docker-compose $(compose_args) up -d
restart:
	$(sudo) docker-compose $(compose_args) restart
rm:
	$(sudo) docker-compose $(compose_args) rm -f
stop:
	$(sudo) docker-compose $(compose_args) stop
logs:
	$(sudo) docker-compose $(compose_args) logs

rmi:
	$(sudo) docker rmi $(IMAGE_NAME):$(VERSION) || true

### packaging ###
# 
# PACKAGENAME = relative basename path of this dir
PACKAGENAME ?= $(shell echo $$(basename $$(pwd)))
IMAGE_NAME ?= ci-tool-stack/service-config
VERSION ?= latest
#
version:
	@echo $(PACKAGENAME) $(VERSION)
package:
	@echo '# $@ STARTING'
	@bash ./tools/package.sh $(PACKAGENAME) $(VERSION)
	@echo '# $@ SUCCESS'
clean-package:
	rm -rf dist ||true

test: build unit-test
	@echo '# $@ SUCCESS'


unit-test:
	@echo '# $@ STARTING'
	( cd tests && bash unit-test.sh $(PACKAGENAME) $(VERSION) )
	@echo '# $@ SUCCESS'

publish: package dist/$(PACKAGENAME)-$(VERSION).tar.gz
	@echo "# $@ STARTING"
	bash ./tools/publish.sh $(PACKAGENAME) $(VERSION)
	@echo '# $@ SUCCESS'

push:
	@echo "# $@ STARTING"
	bash ./tools/push.sh $(IMAGE_NAME) $(VERSION)
	@echo '# $@ SUCCESS'

clean-image:
	$(sudo) docker rmi $(IMAGE_NAME):$(VERSION) || true
