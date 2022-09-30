postgres:
	docker run --name postgres14 --network go-aws-micro-network -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock