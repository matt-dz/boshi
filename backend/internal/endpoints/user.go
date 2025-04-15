package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"errors"
	"net/http"

	"github.com/jackc/pgx/v5"
)

type verificationStatusResponse struct {
	Verified bool `json:"verified"`
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
		log.ErrorContext(logCtx, "Error encoding response")
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

}
