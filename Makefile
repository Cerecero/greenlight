run:
	go run ./cmd/api

psql:
	psql ${DB_URL}

migration:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

up:
	@echo 'Running migrations...'
	sudo migrate -path ./migrations -database ${DB_URL} up
