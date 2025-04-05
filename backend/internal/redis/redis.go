package redis

import (
	"boshi-backend/internal/logger"
	"log/slog"
	"os"
	"sync"
	"time"

	"github.com/redis/go-redis/v9"
)

var log = logger.GetLogger()
var redisOpt *redis.Options
var redisClient *redis.Client
var once sync.Once

const EmailVerficationCodeKey = "email-verification-code"

var EmailVerificationCodeTTL = time.Duration(10) * time.Minute

func init() {
	var err error
	redisOpt, err = redis.ParseURL(os.Getenv("REDIS_URL"))
	if err != nil {
		log.Error("Failed to parse Redis URL", slog.Any("error", err))
		panic(err)
	}
}

func GetClient() *redis.Client {
	once.Do(func() {
		redisClient = redis.NewClient(redisOpt)
	})
	return redisClient
}

func CloseRedis() {
	if redisClient != nil {
		err := redisClient.Close()
		if err != nil {
			log.Error("Failed to close Redis client", slog.Any("error", err))
		}
	}
}
