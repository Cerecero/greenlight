## help: print this help message
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## run/api: run the cmd/api application
run/api:
	go run ./cmd/api

## db/psql: connect to the database using psql
db/psql:
	psql ${DB_URL}

## db/migration/new name=$1: create a new database migration
db/migration/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

## db/migrations/up: apply all up database migrations
db/migrations/up: confirm
	@echo 'Running migrations...'
	sudo migrate -path ./migrations -database ${DB_URL} up
