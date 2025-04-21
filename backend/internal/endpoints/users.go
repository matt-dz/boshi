package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"errors"
	"log/slog"

	"net/http"

	"github.com/jackc/pgx/v5"
)

func GetUsersByID(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	db := database.GetDb(ctx)
	sqlcDb := sqlc.New(db)

	log.DebugContext(r.Context(), "Getting users")

	userIDs := r.URL.Query()["user_id"]
	if len(userIDs) == 0 {
		log.ErrorContext(r.Context(), "No user ids specified")
		http.Error(w, "No user ids specified", http.StatusBadRequest)
		return
	}

	usersResponse, err := sqlcDb.GetUsers(ctx, userIDs)
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to get users", slog.Any("error", err))
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	var convertedResponse []getUserResponse
	for _, u := range usersResponse {
		userResponse := getUserResponse(u)
		log.DebugContext(r.Context(), "User response", slog.Any("user", userResponse))
		if userResponse.School.Valid {
			convertedResponse = append(convertedResponse, userResponse)
		}
	}

	if len(convertedResponse) == 0 {
		log.ErrorContext(r.Context(), "No users found")
		http.Error(w, "No users found", http.StatusNotFound)
		return
	}

	// Map the result to the User struct
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(getUsersResponse{
		Users: convertedResponse,
	})
}

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
	if errors.Is(err, pgx.ErrNoRows) {
		log.ErrorContext(r.Context(), "No row returned - user does not exist")
		http.Error(w, "User does not exist", http.StatusNotFound)
		return
	} else if err != nil {
		log.ErrorContext(r.Context(), "Failed to get user", slog.Any("error", err))
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Map the result to the User struct
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(getUserResponse(userResponse))
}
