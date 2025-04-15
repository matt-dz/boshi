package endpoints

import (
	"boshi-backend/internal/database"
	boshiRedis "boshi-backend/internal/redis"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"

	"github.com/jackc/pgx/v5"
)

type verificationStatusResponse struct {
	Verified bool `json:"verified"`
}

type getCodeExpiryResponse struct {
	Expiry float64 `json:"expiry"`
}

func GetVerificationStatus(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	logCtx := r.Context()
	db := database.GetDb(ctx)
	sqlcDb := sqlc.New(db)

	userId := r.PathValue("user_id")
	logCtx = context.WithValue(logCtx, "user_id", userId)
	log.DebugContext(logCtx, "Getting verification status")
	verified, err := sqlcDb.VerificationStatus(ctx, userId)
	if errors.Is(err, pgx.ErrNoRows) {
		log.DebugContext(logCtx, "User not found")
	} else if err != nil {
		log.ErrorContext(logCtx, "Error getting verification status")
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	log.DebugContext(logCtx, "Encoding response")
	w.Header().Set("Content-Type", "application/json")
	err = json.NewEncoder(w).Encode(
		verificationStatusResponse{
			Verified: err == nil && !verified.Time.IsZero(),
		},
	)
	if err != nil {
		log.ErrorContext(logCtx, "Error encoding response", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

}

func GetCodeExpiry(w http.ResponseWriter, r *http.Request) {
	userId := r.PathValue("user_id")

	ctx := context.Background()
	logCtx := context.WithValue(r.Context(), "user_id", userId)
	db := database.GetDb(ctx)
	sqlcDb := sqlc.New(db)

	// Retrieve user email
	log.DebugContext(logCtx, "Getting user email")
	email, err := sqlcDb.GetEmail(ctx, userId)
	if errors.Is(err, pgx.ErrNoRows) {
		log.DebugContext(logCtx, "User not found")
		http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
		return
	} else if err != nil {
		log.ErrorContext(logCtx, "Error getting email", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	// Retrieve user code expiry
	key := generateVerificationRedisKey(email)
	logCtx = context.WithValue(logCtx, "key", key)
	redisClient := boshiRedis.GetClient()
	log.DebugContext(logCtx, "Getting code expiry")
	duration, err := redisClient.TTL(ctx, key).Result()
	if err != nil {
		log.ErrorContext(logCtx, "Error getting code expiry", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	if duration == -2 {
		log.DebugContext(logCtx, "Code not found")
		http.Error(w, "Code not found", http.StatusNotFound)
		return
	}
	if duration == -1 {
		log.DebugContext(logCtx, "Code expired")
		http.Error(w, "Code expired", http.StatusGone)
		return
	}

	log.DebugContext(r.Context(), "Encoding response")
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(
		getCodeExpiryResponse{
			Expiry: max(duration.Seconds(), 0),
		},
	)
}
