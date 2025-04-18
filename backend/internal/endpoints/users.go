package endpoints

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log/slog"
	"time"

	"net/http"

	"github.com/jackc/pgx/v5/pgtype"
)

func ResolveSchoolFromEmail(email string) (string, error) {
	domain, err := parseEmail(email)
	if err != nil {
		return "", err
	}

	resp, err := http.Get(fmt.Sprintf("http://universities.hipolabs.com/search?domain=%s", domain))
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var result UniversityDomainResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return "", err
	}

	return result.Domains[0].Name, nil
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
	if err != nil {
		log.ErrorContext(r.Context(), "Failed to get user", slog.Any("error", err))
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Assert the interface{} to the expected tuple (school, email, verified_at)
	result, ok := userResponse.([]any)
	if !ok {
		log.ErrorContext(r.Context(), "Unexpected result from DB")
		http.Error(w, "Unexpected result from DB", http.StatusInternalServerError)
		return
	}

	// Map the result to the User struct
	userResponseStruct := getUserResponse{
		School: "Unknown School",
		VerifiedAt: pgtype.Timestamptz{Time: time.Unix(0, 0)},
	}

	if len(result) >= 3 {
		if school, ok := result[0].(string); ok {
			if school == pgtype.Empty.String() {
				log.DebugContext(r.Context(), "School empty - resolving school from email")
				if email, ok := result[1].(string); ok {
					resolvedSchool, err := ResolveSchoolFromEmail(email)
					if err != nil {
						log.ErrorContext(r.Context(), "Failed to resolve school", slog.Any("error", err))
						http.Error(w, err.Error(), http.StatusInternalServerError)
						return
					}
					
					_, err = sqlcDb.UpsertSchool(ctx, 
						sqlc.UpsertSchoolParams{
							UserID: userID, 
							School: pgtype.Text{
								String: school, 
								Valid: true,
							},
						},
					)

					if err != nil {
						log.ErrorContext(r.Context(), "Failed to upsert school", slog.Any("error", err))
						http.Error(w, err.Error(), http.StatusInternalServerError)
						return
					}
					
					school = resolvedSchool
				} else {
					log.WarnContext(r.Context(), "Failed to deduce email from db response")
				}
			}
			userResponseStruct.School = school
		} else {
			log.WarnContext(r.Context(), "Failed to deduce school from db response")
		}
		if verifiedAt, ok := result[2].(pgtype.Timestamptz); ok {
			userResponseStruct.VerifiedAt = verifiedAt
		} else {
			log.WarnContext(r.Context(), "Failed to deduce verified timestamp from db response")
		}
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(userResponseStruct)
}
