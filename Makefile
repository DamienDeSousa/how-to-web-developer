MAKE=make

SHELL := /bin/bash

DOCKER_COMPOSE := docker-compose
DOCKER_SERVER := $(DOCKER_COMPOSE) exec server

CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)
CURRENT_PWD := $(shell pwd)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fix-permission: ## fix permission on project files
	sudo chown ${CURRENT_UID}:${CURRENT_GID} -R .
	$(DOCKER_SERVER) chown www-data:www-data -R var

npm-install: ## npm install
	$(DOCKER_SERVER) npm install

npm-build: ## npm run build
	$(DOCKER_SERVER) npm run build

npm-init:
	$(DOCKER_SERVER) npm init

clear-cache: ## clear all cache
	$(MAKE) clear-admin-cache
	$(MAKE) clear-website-cache

clear-admin-cache: ## clear admin cache
	$(DOCKER_SERVER) php bin/adminconsole cache:clear --no-warmup
	$(DOCKER_SERVER) php bin/adminconsole cache:clear --no-warmup --env=dev

clear-website-cache:
	$(DOCKER_SERVER) php bin/websiteconsole cache:clear --no-warmup
	$(DOCKER_SERVER) php bin/websiteconsole cache:clear --no-warmup --env=dev

up: ## up docker stack
	$(DOCKER_COMPOSE) up -d --build

down: ## down docker stack
	$(DOCKER_COMPOSE) down