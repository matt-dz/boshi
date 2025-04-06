package database

import (
	"boshi-backend/internal/logger"
	"context"
	"os"
	"sync"

	"github.com/jackc/pgx/v5/pgxpool"
)

var log = logger.GetLogger()
var once sync.Once
var pgUrl string
var pool *pgxpool.Pool

func init() {
	pgUrl = os.Getenv("POSTGRES_URL")
	if pgUrl == "" {
		panic("POSTGRES_URL not set")
	}
}

// Retrieves a singleton instance of the Redis client.
func GetDb(ctx context.Context) *pgxpool.Pool {
	once.Do(func() {
		var err error
		pool, err = pgxpool.New(ctx, pgUrl)
		if err != nil {
			panic(err)
		}
	})
	return pool
}

// Closes redis connection. Should only be called when the
// application is shutting down.
func CloseDb() {
	if pool != nil {
		pool.Close()
	}
}
