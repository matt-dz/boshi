package database

import (
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/sqlc"
	"context"
	"os"
	"sync"

	"github.com/jackc/pgx/v5/pgxpool"
)

var (
	log     = logger.GetLogger()
	once    sync.Once
	pool    *pgxpool.Pool
	queries *sqlc.Queries
)

func connect(ctx context.Context) {
	log.Debug("Connecting to postgres")
	var err error
	pool, err = pgxpool.New(ctx, os.Getenv("POSTGRES_URL"))
	if err != nil {
		panic(err)
	}
	log.Debug("Successfully connected to DB")
	queries = sqlc.New(pool)
}

func UseQueries(ctx context.Context) *sqlc.Queries {
	once.Do(func() {
		connect(ctx)
	})
	return queries
}

func Close() {
	pool.Close()
}
