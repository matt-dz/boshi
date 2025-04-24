package endpoints

import (
	"boshi-backend.com/internal/logger"
	"encoding/json"
	"fmt"
	"log/slog"
	"net/http"
	"os"
)

var log = logger.GetLogger()

// Returns client-metadata.json for initiating OAuth2 authorization code flow
func ServeOAuthMetadata(w http.ResponseWriter, r *http.Request) {
	oauthBaseURL := os.Getenv("OAUTH_BASE_URL")
	if oauthBaseURL == "" {
		log.ErrorContext(r.Context(), "OAUTH_BASE_URL not set")
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	redirectURI := os.Getenv("OAUTH_REDIRECT_URI")
	if redirectURI == "" {
		log.ErrorContext(r.Context(), "OAUTH_REDIRECT_URI not set")
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	log.DebugContext(r.Context(), "Encoding client metadata")
	w.Header().Set("Content-Type", "application/json")
	err := json.NewEncoder(w).Encode(clientMetadata{
		ClientID:                fmt.Sprintf("%s/client-metadata.json", oauthBaseURL),
		ClientName:              "Boshi",
		ClientURI:               oauthBaseURL,
		RedirectURIs:            []string{redirectURI},
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
