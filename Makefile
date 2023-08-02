TSV=5.0
NODE=18
NVMV=0.39.3

PHP_SRC=src/initphp/php/
VENDOR=src/initphp/php/vendor
PCO=src/initphp/ts/configs/project.js
COM_BIN=$(HOME)/.local/bin/composer
NVM_DIR=$(HOME)/.nvm

NVM=[ -s $(NVM_DIR)/nvm.sh ] && \. $(NVM_DIR)/nvm.sh && nvm
ifeq ($(shell grep "production:\s*true," $(PCO)),)
NODE_ENV=development
POST=bash bin/deploy/post.sh
else
NODE_ENV=production
POST=echo "no post in production"
endif
NPM=[ -s $(NVM_DIR)/nvm.sh ] && \. $(NVM_DIR)/nvm.sh && NODE_ENV=$(NODE_ENV) npm
COMPOSER=COMPOSER=$(shell pwd)/configs/dev/composer.json $(COM_BIN)
export PATH:=$(PATH):$(shell pwd)/$(VENDOR)/bin

dev: actDev setup
	$(COMPOSER) install -d $(PHP_SRC) 
	$(NPM) install 
	$(NPM) run hook

tests: actDev setup
	$(COMPOSER) install -d $(PHP_SRC)
	$(NPM) install --omit optional

build: setup 
	$(COMPOSER) install -d $(PHP_SRC) --no-dev
	$(NPM) install --omit dev --omit optional

docs: setup
	echo "TODO docs not implemented - actDev or actProd required"
	$(COMPOSER) install -d $(PHP_SRC) --no-dev
	$(NPM) install --omit dev

setupNode:
	curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$(NVMV)/install.sh" | bash
	$(NVM) install 18 
	$(NVM) use $(NODE)
	rm -rf node_modules

setupComposer:
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	[ `sha384sum composer-setup.php | cut -f 1 -d " "` == "e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02" ] \
	|| echo -e "\033[0;31mInstaller corrupt - consider updating sha384\033[0m";
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar $(COM_BIN)
	rm -rf $(VENDOR)

setup: setupNode setupComposer
	git lfs install
	$(POST)

uninstall:
	rm -rf $(NVM_DIR)

runAct: 
	$(NPM) -v
	bash

actDev:	
	sed -i -E 's/(production\s*:)\s*[falstrue]+,/\1 false,/g' $(PCO)
	$(eval NODE_ENV=development)
	$(eval POST=bash bin/deploy/post.sh)
	$(eval NPM=[ -s $(NVM_DIR)/nvm.sh ] && \. $(NVM_DIR)/nvm.sh && NODE_ENV=$(NODE_ENV) npm)

actProd:
	sed -i -E 's/(production\s*:)\s*[falstrue]+,/\1 true,/g' $(PCO)
	$(eval NODE_ENV=production)
	$(eval POST=echo "no post in production")
	$(eval NPM=[ -s $(NVM_DIR)/nvm.sh ] && \. $(NVM_DIR)/nvm.sh && NODE_ENV=$(NODE_ENV) npm)

runCheck: runBuild
	$(NPM) run lint
	$(NPM) run lint:prune
	$(NPM) run lint:eslint
	$(NPM) run lint:prettier
	$(NPM) run lint:shell
	$(NPM) run lint:phpstan
	$(NPM) run lint:phpinsights
	$(NPM) run lint:phpchurn

runDocs:
	echo "TODO"

runTests:
	echo "TODO"

runBuild:
	$(NPM) run build

runUpdate:
	$(NPM) update
	rm -rf $(VENDOR)
	$(COMPOSER) update -d $(PHP_SRC) 

commit: 
	$(NPM) run cz