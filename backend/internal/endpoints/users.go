package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"log/slog"
	"time"

	"net/http"

	"github.com/jackc/pgx/v5/pgtype"
)

func GetUserByID(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	db := database.GetDb(ctx)
	sqlcDb := sqlc.New(db)

	log.DebugContext(r.Context(), "Getting user")

	userID := r.PathValue("user_id")
	if userID == "" {
		log.ErrorContext(r.Context(), "No user id specified")
		http.Error(w, "No user id specified", http.StatusBadRequest)
		return
	}

	userResponse, err := sqlcDb.GetUser(ctx, userID)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to get user", slog.Any("error", err))
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Assert the interface{} to the expected tuple (school, verified_at)
	result, ok := userResponse.([]any)
	if !ok {
		log.ErrorContext(r.Context(), "Unexpected result from DB")
		http.Error(w, "Unexpected result from DB", http.StatusInternalServerError)
		return
	}

	// Map the result to the User struct
	var userResponseStruct getUserResponse
	if len(result) >= 2 {
		// Assert and assign values
		if school, ok := result[0].(string); ok {
			userResponseStruct.School = school
		}
		if verifiedAtRaw, ok := result[1].(string); ok {
			verifiedAt, err := time.Parse(time.RFC3339Nano, verifiedAtRaw)
			if err != nil {
				log.Info("Invalid timestamp format", slog.Any("error", err))
			}
			userResponseStruct.VerifiedAt = pgtype.Timestamptz{Time: verifiedAt, Valid: true}
		}
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(userResponseStruct)
}
