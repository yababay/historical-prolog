all: down build up debug

build:
	docker-compose build prolog

debug:
	docker exec -it historical_prolog /bin/bash

test: down build up
	docker exec -it historical_prolog /usr/bin/swipl -q -g run_tests -t halt util/persons.prolog util/grammar.prolog

up:
	docker-compose up -d 

down:
	docker-compose up -d --remove-orphans

