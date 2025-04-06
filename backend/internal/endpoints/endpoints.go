package endpoints

import (
	"boshi-backend/internal/logger"
	"encoding/json"
	"fmt"
	"log/slog"
	"net/http"
	"os"
)

var log = logger.GetLogger()

// Returns client-metadata.json for initiating OAuth2 authorization code flow
func ServeOAuthMetadata(w http.ResponseWriter, r *http.Request) {
	domain := os.Getenv("DOMAIN")
	if domain == "" {
		log.ErrorContext(r.Context(), "DOMAIN not set")
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

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
