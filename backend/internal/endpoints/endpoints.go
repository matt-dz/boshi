package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/email"
	"boshi-backend/internal/logger"
	boshiRedis "boshi-backend/internal/redis"
	"boshi-backend/internal/sqlc"
	"context"
	"crypto/subtle"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"net/mail"
	"os"
	"strings"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/redis/go-redis/v9"
)

var log = logger.GetLogger()
var db = database.GetDb(context.Background())
var sqlcDb = sqlc.New(db)

var pgError *pgconn.PgError

var ErrVerificationCodeExists = fmt.Errorf("verification code already exists")

func generateVerificationRedisKey(email string) string {
	return fmt.Sprintf("%s:%s", boshiRedis.EmailVerficationCodeKey, email)
}

// Returns client-metadata.json for initiating OAuth2 authorization code flow
func ServeOAuthMetadata(w http.ResponseWriter, r *http.Request) {
	domain := os.Getenv("DOMAIN")

	log.DebugContext(r.Context(), "Encoding client metadata")
	w.Header().Set("Content-Type", "application/json")
	err := json.NewEncoder(w).Encode(clientMetadata{
		ClientID:                fmt.Sprintf("https://%s/oauth/client-metadata.json", domain),
		ClientName:              "Boshi",
		ClientURI:               fmt.Sprintf("https://%s", domain),
		RedirectURIs:            []string{fmt.Sprintf("https://%s/login/redirect/", domain)},
		GrantTypes:              []string{"authorization_code", "refresh_token"},
		Scope:                   "atproto transition:generic",
		ResponseTypes:           []string{"code"},
		TokenEndpointAuthMethod: "none",
		ApplicationType:         "web",
		DpopBoundAccessTokens:   true,
	})

	if err != nil {
		log.ErrorContext(r.Context(), "Failed to encode response", slog.Any("error", err))
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
	}
}

func HandleAddEmailToEmailList(w http.ResponseWriter, r *http.Request) {
	// Decode Payload
	log.DebugContext(r.Context(), "Decoding payload")
	var payload emailListPayload
	err := decodeJson(&payload, r)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to decode payload", slog.Any("error", err))
		http.Error(w, "Failed to decode payload", http.StatusBadRequest)
		return
	}

	// Validate email
	log.DebugContext(r.Context(), "Validating email")
	if _, err := mail.ParseAddress(payload.Email); err != nil {
		log.ErrorContext(r.Context(), "Invalid email address", slog.Any("error", err))
		http.Error(w, "Invalid email address", http.StatusBadRequest)
		return
	}

	// Insert email into database
	log.DebugContext(r.Context(), "Inserting email into database")
	if err := sqlcDb.AddToMailList(r.Context(), payload.Email); err != nil {
		if pgError, ok := err.(*pgconn.PgError); ok && pgError.Code == "23505" {
			// Check for unique constraint violation
			log.DebugContext(r.Context(), "Email already exists in database")
			http.Error(w, http.StatusText(http.StatusConflict), http.StatusConflict)
			return
		}
		log.ErrorContext(r.Context(), "Failed to insert email into database", slog.Any("error", err))
		http.Error(w, "Failed to insert email into database", http.StatusInternalServerError)
		return
	}

	// Send email
	log.InfoContext(r.Context(), "Sending email")
	err = email.SendEmail(
		payload.Email,
		"Welcome to Boshi",
		"Thank you for signing up for the Boshi mail list! We are excited that you've decided to join us on our journey. Updates are coming soon.",
	)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to send email", slog.Any("error", err))
		http.Error(w, "Failed to send email", http.StatusInternalServerError)
		return
	}
}

func CreateEmailVerificationCode(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	// Decode Payload
	log.DebugContext(r.Context(), "Decoding payload")
	var payload emailListPayload
	err := decodeJson(&payload, r)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to decode payload", slog.Any("error", err))
		http.Error(w, "Failed to decode payload", http.StatusBadRequest)
		return
	}

	// Validate email
	log.DebugContext(r.Context(), "Validating email")
	if _, err := mail.ParseAddress(payload.Email); err != nil {
		log.ErrorContext(r.Context(), "Invalid email address", slog.Any("error", err))
		http.Error(w, "Invalid email address", http.StatusBadRequest)
		return
	}
	if !strings.HasSuffix(payload.Email, ".edu") {
		log.ErrorContext(r.Context(), "Email address must end with .edu", slog.String("email", payload.Email))
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}

	// Add email to database and check if it is already verified
	log.DebugContext(r.Context(), "Begin database transaction")
	tx, err := db.Begin(ctx)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to begin transaction", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	defer tx.Rollback(ctx)
	qtx := sqlcDb.WithTx(tx)

	// Insert email into database
	log.DebugContext(r.Context(), "Inserting email into database")
	txR, err := qtx.AddUnverifiedEmail(ctx, payload.Email)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to insert email into database", slog.Any("error", err))
		http.Error(w, "Failed to insert email into database", http.StatusInternalServerError)
		return
	}

	// Check if email is already verified
	log.DebugContext(r.Context(), "Check if email is already verified")
	if !txR.VerifiedAt.Time.IsZero() {
		log.ErrorContext(r.Context(), "Email already verified", slog.String("email", payload.Email))
		http.Error(w, "Email already verified", http.StatusConflict)
		return
	}

	log.DebugContext(r.Context(), "Committing transaction")
	if err := tx.Commit(ctx); err != nil {
		log.ErrorContext(r.Context(), "Failed to commit transaction", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	// Generate random code
	log.DebugContext(r.Context(), "Generating code")
	code, err := email.GenerateVerificationCode()
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to generate verification code", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	// Insert code into redis
	log.DebugContext(r.Context(), "Inserting code into redis")
	key := generateVerificationRedisKey(payload.Email)
	// key := "example"
	log.DebugContext(r.Context(), "Key", slog.String("key", key))
	var redisClient = boshiRedis.GetClient()

	// Set the key if it is not already set
	ok, err := redisClient.SetNX(
		ctx,
		key,
		code,
		boshiRedis.EmailVerificationCodeTTL,
	).Result()
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to set verification code in redis", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	if !ok {
		log.ErrorContext(r.Context(), "Key already exists, not setting.", slog.String("key", key))
		http.Error(w, "Verification code already set", http.StatusConflict)
		return
	}

	// Send email
	log.DebugContext(r.Context(), "Sending email")
	err = email.SendEmail(
		payload.Email,
		"Boshi Email Verification Code",
		fmt.Sprintf("Your Boshi verification code is: %s", code),
	)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to send email", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
}

func VerifyEmailCode(w http.ResponseWriter, r *http.Request) {
	// Decode payload
	ctx := context.Background()

	// Decode Payload
	log.DebugContext(r.Context(), "Decoding payload")
	var payload verifyEmailVerificationCodePayload
	err := decodeJson(&payload, r)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to decode payload", slog.Any("error", err))
		http.Error(w, "Failed to decode payload", http.StatusBadRequest)
		return
	}

	// Begin postgres transaction to make update process "transactional"
	// The verification status will *only* be updated if the redis transaction
	// is also successful. Otherwise, the update will be rolled back.
	tx, err := db.Begin(ctx)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to begin transaction", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	defer tx.Rollback(ctx)
	qtx := sqlcDb.WithTx(tx)
	_, err = qtx.VerifyEmail(ctx, payload.Email)
	if errors.Is(err, pgx.ErrNoRows) {
		log.ErrorContext(r.Context(), "Email not found", slog.String("email", payload.Email))
		http.Error(w, "Email not found", http.StatusNotFound)
		return
	} else if err != nil {
		log.ErrorContext(
			r.Context(),
			"Failed to update verification status",
			slog.Any("error", err),
			slog.String("email", payload.Email),
		)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	// Get code from redis
	key := generateVerificationRedisKey(payload.Email)
	log.DebugContext(r.Context(), "Retrieving key from redis", slog.String("key", key))
	redisClient := boshiRedis.GetClient()
	code, err := redisClient.Get(ctx, key).Result()
	if errors.Is(err, redis.Nil) {
		log.ErrorContext(r.Context(), "Key not found", slog.String("key", key))
		http.Error(w, "Invalid Key", http.StatusNotFound)
		return
	} else if err != nil {
		log.ErrorContext(r.Context(), "Failed to GET key", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	// Compare codes
	if subtle.ConstantTimeCompare([]byte(code), []byte(payload.Code)) != 1 {
		log.ErrorContext(r.Context(), "Codes do not match")
		http.Error(w, http.StatusText(http.StatusConflict), http.StatusConflict)
		return
	}

	// Delete key
	err = redisClient.Del(ctx, key).Err()
	if errors.Is(err, redis.Nil) {
		log.ErrorContext(r.Context(), "Key not found", slog.String("key", key))
		http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
		return
	} else if err != nil {
		log.ErrorContext(r.Context(), "Failed to DEL key", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	log.DebugContext(r.Context(), "Successfully removed key")

	// Commit transaction - this is not fully transaction, but good enough
	if err := tx.Commit(ctx); err != nil {
		log.ErrorContext(r.Context(), "Failed to commit db transaction", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
}
