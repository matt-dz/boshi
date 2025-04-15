package main

import (
	"boshi-backend/internal/database"
	"boshi-backend/internal/endpoints"
	"boshi-backend/internal/logger"
	"boshi-backend/internal/middleware"
	"boshi-backend/internal/redis"
	"fmt"
	"net/http"
	"os"
)

var log = logger.GetLogger()

func cleanup() {
	database.CloseDb()
	redis.CloseRedis()
}

func main() {
	log.Info("Starting server...")
	defer cleanup()

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
			endpoints.AddEmailToEmailList,
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("POST /email/code",
		middleware.Chain(
			endpoints.CreateEmailVerificationCode,
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("POST /email/verify",
		middleware.Chain(
			endpoints.VerifyEmailCode,
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("GET /user/{user_id}/verification-status",
		middleware.Chain(
			endpoints.GetVerificationStatus,
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
