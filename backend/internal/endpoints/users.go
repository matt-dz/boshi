package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"log/slog"

	"net/http"
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

	// Map the result to the User struct
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(userResponse)
}
