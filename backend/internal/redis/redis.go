// Package for handling Redis connections
package redis

import (
	"boshi-backend.com/internal/logger"
	"log/slog"
	"os"
	"sync"

	"github.com/redis/go-redis/v9"
)

var log = logger.GetLogger()
var redisOpt *redis.Options
var redisClient *redis.Client
var once sync.Once

func init() {
	var err error
	redisOpt, err = redis.ParseURL(os.Getenv("REDIS_URL"))
	if err != nil {
		log.Error("Failed to parse Redis URL", slog.Any("error", err))
		panic(err)
	}
}

// Retrieves a singleton instance of the Redis client.
func GetClient() *redis.Client {
	once.Do(func() {
		redisClient = redis.NewClient(redisOpt)
	})
	return redisClient
}

// Closes redis connection. Should only be called when the
// application is shutting down.
func CloseRedis() {
	if redisClient != nil {
		err := redisClient.Close()
		if err != nil {
			log.Error("Failed to close Redis client", slog.Any("error", err))
		}
	}
}
