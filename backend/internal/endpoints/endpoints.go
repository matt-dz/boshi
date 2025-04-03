package endpoints

import (
	"boshi-backend/internal/cors"
	"boshi-backend/internal/database"
	"boshi-backend/internal/email"
	"boshi-backend/internal/logger"
	"boshi-backend/internal/sqlc"
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"net/http"
	"net/mail"
	"os"

	"github.com/jackc/pgx/v5/pgconn"
)

var log = logger.GetLogger()
var db = database.Connect(context.Background())
var sqlcDb = sqlc.New(db)

var pgError *pgconn.PgError

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
	if err := sqlcDb.InsertEmail(r.Context(), payload.Email); err != nil {
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
	if err := email.SendEmailListWelcome(payload.Email); err != nil {
		log.ErrorContext(r.Context(), "Failed to send email", slog.Any("error", err))
		http.Error(w, "Failed to send email", http.StatusInternalServerError)
		return
	}
}

func AddCors(w http.ResponseWriter, r *http.Request) {
	cors.AddCors(w, r)
}
