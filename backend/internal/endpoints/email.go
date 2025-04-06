package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/email"
	boshiRedis "boshi-backend/internal/redis"
	"boshi-backend/internal/sqlc"
	"context"
	"crypto/subtle"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"net/mail"
	"regexp"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/redis/go-redis/v9"
)

const EmailVerficationCodeKey = "email-verification-code"

var DIDRegex = regexp.MustCompile(`^did:[a-z]+:[a-zA-Z0-9._:%-]*[a-zA-Z0-9._-]$`)

var EmailVerificationCodeTTL = time.Duration(10) * time.Minute
var pgError *pgconn.PgError

func generateVerificationRedisKey(email string) string {
	return fmt.Sprintf("%s:%s", EmailVerficationCodeKey, email)
}

func AddEmailToEmailList(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	var db = database.GetDb(ctx)
	var sqlcDb = sqlc.New(db)

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
	if err := sqlcDb.AddToMailList(ctx, payload.Email); err != nil {
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
	var db = database.GetDb(ctx)
	var sqlcDb = sqlc.New(db)

	// Decode Payload
	log.DebugContext(r.Context(), "Decoding payload")
	var payload createEmailVerificationCodePayload
	err := decodeJson(&payload, r)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to decode payload", slog.Any("error", err))
		http.Error(w, "Failed to decode payload", http.StatusBadRequest)
		return
	}

	// Validate user id
	if !DIDRegex.MatchString(payload.UserID) {
		log.ErrorContext(r.Context(), "user_id not a valid DID", slog.String("did", payload.UserID))
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
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
	txR, err := qtx.UpsertEmail(ctx, sqlc.UpsertEmailParams{
		UserID: payload.UserID,
		Email:  payload.Email,
	})
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

	// Commit transaction
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
		EmailVerificationCodeTTL,
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
		"Boshi Verification Code",
		fmt.Sprintf("Your Boshi verification code is: %s", code),
	)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to send email", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
}

func VerifyEmailCode(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	var db = database.GetDb(ctx)
	var sqlcDb = sqlc.New(db)

	// Decode Payload
	log.DebugContext(r.Context(), "Decoding payload")
	var payload verifyEmailVerificationCodePayload
	err := decodeJson(&payload, r)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to decode payload", slog.Any("error", err))
		http.Error(w, "Failed to decode payload", http.StatusBadRequest)
		return
	}

	// Validate user id
	if !DIDRegex.MatchString(payload.UserID) {
		log.ErrorContext(r.Context(), "user_id not a valid DID", slog.String("did", payload.UserID))
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}

	// Begin postgres transaction to make update process "transactional"
	// The verification status will *only* be updated if the redis transaction
	// is also successful. Otherwise, the update will be rolled back.
	log.InfoContext(r.Context(), "Beginning database transaction")
	tx, err := db.Begin(ctx)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to begin transaction", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	defer tx.Rollback(ctx)
	qtx := sqlcDb.WithTx(tx)

	log.DebugContext(r.Context(), "Updating verification status")
	_, err = qtx.VerifyEmail(ctx, sqlc.VerifyEmailParams{
		UserID: payload.UserID,
		Email:  payload.Email,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		log.ErrorContext(
			r.Context(),
			"Email not associated with user_id",
			slog.String("user_id", payload.UserID),
			slog.String("email", payload.Email),
		)
		http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
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
	log.DebugContext(r.Context(), "Comparing codes")
	if subtle.ConstantTimeCompare([]byte(code), []byte(payload.Code)) != 1 {
		log.ErrorContext(r.Context(), "Codes do not match")
		http.Error(w, http.StatusText(http.StatusConflict), http.StatusConflict)
		return
	}

	// Delete key
	log.DebugContext(r.Context(), "Removing key from redis")
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
	log.DebugContext(r.Context(), "Committing transaction")
	if err := tx.Commit(ctx); err != nil {
		log.ErrorContext(r.Context(), "Failed to commit db transaction", slog.Any("error", err))
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
}
