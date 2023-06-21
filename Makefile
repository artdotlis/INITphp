TSV=5.0
NODE=18
NVMV=0.39.3

PHP_SRC=src/initphp/php/
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
export PATH := $(PATH):$(shell pwd)/$(PHP_SRC)vendor/bin

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
	php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar $(COM_BIN)

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

actProd:
	sed -i -E 's/(production\s*:)\s*[falstrue]+,/\1 true,/g' $(PCO)

runCheck: runBuild
	$(NPM) run lint
	$(NPM) run lint:prune
	$(NPM) run lint:eslint
	$(NPM) run lint:prettier
	$(NPM) run lint:shell
	$(NPM) run lint:phpstan
	$(NPM) run lint:phpinsights

runDocs:
	echo "TODO"

runTests:
	echo "TODO"

runBuild:
	$(NPM) run build

runUpdate:
	$(NPM) update
	$(COMPOSER) update -d $(PHP_SRC) 

commit: 
	$(NPM) run cz