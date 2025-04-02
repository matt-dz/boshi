package endpoints

import (
	"boshi-backend/internal/logger"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

var log = logger.GetLogger()

func ServeOauthMetadata(w http.ResponseWriter, r *http.Request) {
	domain := os.Getenv("DOMAIN")

	log.Debug("Encoding client metadata")
	err := json.NewEncoder(w).Encode(ClientMetadata{
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
	w.Header().Set("Content-Type", "application/json")

	if err != nil {
		log.Error("Failed to encode response", "error", err)
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
	}
}
