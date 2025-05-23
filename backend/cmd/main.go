/// The main entry point for the Boshi backend server.

package main

import (
	"boshi-backend.com/internal/database"
	"boshi-backend.com/internal/endpoints"
	"boshi-backend.com/internal/logger"
	"boshi-backend.com/internal/middleware"
	"boshi-backend.com/internal/redis"
	"fmt"
	"net/http"
	"os"
)

var log = logger.GetLogger()

// / The cleanup function is called when the server is shutting down.
func cleanup() {
	database.CloseDb()
	redis.CloseRedis()
}

// / The main function is the entry point for the server.
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

	mux.HandleFunc("GET /users",
		middleware.Chain(
			endpoints.GetUsersByID,
			middleware.AddCors(),
			middleware.LogRequest(),
		),
	)

	mux.HandleFunc("GET /user/{user_id}",
		middleware.Chain(
			endpoints.GetUserByID,
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

	mux.HandleFunc("GET /user/{user_id}/code/ttl",
		middleware.Chain(
			endpoints.GetCodeExpiry,
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
