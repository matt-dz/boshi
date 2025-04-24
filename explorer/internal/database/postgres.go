package database

import (
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/sqlc"
	"context"
	"os"
	"sync"

	"github.com/jackc/pgx/v5/pgxpool"
)

// Defined constants to support a singleton db
var (
	log     = logger.GetLogger()
	once    sync.Once
	pool    *pgxpool.Pool
	queries *sqlc.Queries
)

// Create a new pool connection to the psql db
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

// Singleton implementation of the db
func UseQueries(ctx context.Context) *sqlc.Queries {
	once.Do(func() {
		connect(ctx)
	})
	return queries
}

// Close the current connection
func Close() {
	pool.Close()
}
