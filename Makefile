#!/usr/bin/make -f
.SILENT:
.PHONY: help build-image up down ssh build-app test freespace

## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## Exibe as instruções de uso.
help:
	printf "${COLOR_COMMENT}Uso:${COLOR_RESET}\n"
	printf " make [comando]\n\n"
	printf "${COLOR_COMMENT}Comandos disponíveis:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Constroi a imagem.
build-image:
	@echo Construindo as imagens.
	docker-compose build

## Inicia a aplicação.
up:
	make build-image
	docker-compose up

## Desliga a aplicação.
down:
	@echo ?? Desligando os serviços.
	docker-compose down --remove-orphans

## Conecta-se ao container php.
ssh:
	docker-compose exec app bash

## Realiza o build da aplicação
build-app:
	docker-compose exec app \
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a \
		${GO_LDFLAGS} \
		-tags netgo \
		-installsuffix netgo \
		-o app

## Executa os testes da aplicação.
test:
	@echo ? Executando testes
	docker-compose exec app go test -v -cover ./...

## Libera espaço em disco (apaga dados do docker em desuso)
freespace:
	@echo ??? Apagando arquivos do Docker que n�o est�o sendo utilizados
	docker system prune --all --volumes --force
