# Include variables from the .env file
include .env

 # ==================================================================================== #
 # HELPERS
 # ==================================================================================== #
 
## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

 # ==================================================================================== #
 # DEVELOPMENT
 # ==================================================================================== #

## run/api: run the cmd/api application
.PHONY: run/api
run/api:
	@go run ./cmd/api -db-dsn=${DB_URL}

## db/psql: connect to the database using psql
.PHONY: db/psql
db/psql:
	@psql ${DB_URL}

## db/migration/new name=$1: create a new database migration
.PHONY: db/migration/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

## db/migrations/up: apply all up database migrations
.PHONY: db/migrations/up
db/migrations/up: confirm
	@echo 'Running migrations...'
	migrate -path ./migrations -database ${DB_URL} up

 # ==================================================================================== #
 # QUALITY CONTROL
 # ==================================================================================== #

## audit: tidy dependencies and format, vet and test all code
.PHONY: audit
audit: vendor
	@echo 'Formatting code...'
	go fmt ./...
	@echo 'Vetting code...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...

## vendor: tidy and vendor dependencies
.PHONY: vendor
vendor:
	@echo 'Tiding and verifying module dependencies...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies...'
	go mod vendor

 # ==================================================================================== #
 # BUILD
 # ==================================================================================== #

current_time = $(shell date --iso-8601=seconds)
git_description = $(shell git describe --always --dirty --tags --long)
linker_flags = '-s -X main.buildTime=${current_time} -X main.version=${git_description}'

.PHONY: build/api
build/api:
	@echo 'Building cmd/api'
	go build  -ldflags=${linker_flags} -o=./bin/api ./cmd/api
	GOOS=linux GOARCH=amd64 go build  -ldflags=${linker_flags} -o=./bin/linux_amd64/api ./cmd/api
