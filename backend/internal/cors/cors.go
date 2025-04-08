package cors

import (
	"net/http"
	"os"
	"regexp"
)

var remotePattern = regexp.MustCompile(`^https:\/\/(?:\w(?:-|\w)*)?boshi(?:-app|-api)?\.deguzman\.cloud$`)

func validateOrigin(origin string) bool {
	if os.Getenv("ENV") == "PROD" {
		return remotePattern.MatchString(origin)
	}

	return true
}

func AddCors(w http.ResponseWriter, r *http.Request) bool {

	/* If origin is not in allow list, do not add CORS headers */
	origin := r.Header.Get("Origin")
	if !validateOrigin(origin) {
		return false
	}
	w.Header().Add("Access-Control-Allow-Origin", origin)
	w.Header().Add("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
	w.Header().Add("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding")
	w.Header().Add("Access-Control-Allow-Credentials", "true")
	w.Header().Add("Access-Control-Max-Age", "86400")
	return true
}
