package database

import (
	"boshi-backend/internal/logger"
	"context"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var log = logger.GetLogger()
var pgUrl string

func init() {
	pgUrl = os.Getenv("POSTGRES_URL")
	if pgUrl == "" {
		panic("POSTGRES_URL not set")
	}
}

func Connect(ctx context.Context) *pgxpool.Pool {
	pool, err := pgxpool.New(ctx, pgUrl)
	if err != nil {
		panic(err)
	}
	log.Debug("Successfully connected to DB")
	return pool
}
