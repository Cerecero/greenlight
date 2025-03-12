run/api:
	go run ./cmd/api

db/psql:
	psql ${DB_URL}

db/migration/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

db/migrations/up:
	@echo 'Running migrations...'
	sudo migrate -path ./migrations -database ${DB_URL} up
