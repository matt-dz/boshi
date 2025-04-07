package main

import (
	"boshi-backend/internal/endpoints"
	"boshi-backend/internal/logger"
	"boshi-backend/internal/middleware"
	"fmt"
	"net/http"
	"os"
)

var log = logger.GetLogger()

func main() {
	log.Info("Starting server...")

	/* Setup routes */
	mux := http.NewServeMux()

	mux.HandleFunc("OPTIONS /",
		middleware.Chain(
			func(w http.ResponseWriter, r *http.Request) {},
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("GET /health",
		middleware.Chain(
			func(w http.ResponseWriter, r *http.Request) {},
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("GET /client-metadata.json",
		middleware.Chain(
			endpoints.ServeOAuthMetadata,
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("POST /email-list",
		middleware.Chain(
			endpoints.HandleAddEmailToEmailList,
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	/* Setup server*/
	port := os.Getenv("PORT")
	if port == "" {
		log.Info("No port specified, defaulting to 8080")
		port = "8080"
	}

	server := &http.Server{Addr: fmt.Sprintf(":%s", port), Handler: mux}
	log.Info("Listening on port " + port + "...")
	if err := server.ListenAndServe(); err != nil {
		log.Error("Server failed to start ", "error", err)
	}
}
