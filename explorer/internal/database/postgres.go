package database

import (
	"boshi-explorer/internal/logger"
	"context"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var log = logger.GetLogger()

func Connect(ctx context.Context) *pgxpool.Pool {
	pool, err := pgxpool.New(ctx, os.Getenv("POSTGRES_URL"))
	if err != nil {
		panic(err)
	}
	log.Debug("Successfully connected to DB")
	return pool
}
