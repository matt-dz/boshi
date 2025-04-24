// Package for middleware functions

package middleware

import (
	"boshi-backend.com/internal/cors"
	"boshi-backend.com/internal/logger"
	"context"
	"log/slog"
	"net/http"
	"time"
)

var log = logger.GetLogger()
var ctx = context.Background()

// logResponseWriter is a custom ResponseWriter that captures the status code
type logResponseWriter struct {
	http.ResponseWriter
	statusCode int
}

// Write captures the status code and writes the response
func (lrw *logResponseWriter) WriteHeader(code int) {
	lrw.statusCode = code
	lrw.ResponseWriter.WriteHeader(code)
}

// Middleware type alias
type Middleware func(http.HandlerFunc) http.HandlerFunc

// Chain adds middleware in a chained fashion to the HTTP handler.
func Chain(h http.HandlerFunc, m ...Middleware) http.HandlerFunc {

	// Applied in reverse to preserve the order
	for i := len(m) - 1; i >= 0; i-- {
		h = m[i](h.ServeHTTP)
	}

	return h
}

// Logs the request method and path
func LogRequest() Middleware {
	return func(next http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			r = r.WithContext(logger.AppendCtx(r.Context(), slog.String("method", r.Method)))
			r = r.WithContext(logger.AppendCtx(r.Context(), slog.String("path", r.URL.Path)))
			lrw := &logResponseWriter{w, http.StatusOK}
			log.InfoContext(r.Context(), "Request received")
			next(lrw, r)
			log.InfoContext(r.Context(), "Request handled", slog.String("duration", time.Since(start).String()), slog.Int("status", lrw.statusCode))
		}
	}
}

// Adds CORS headers to the response
func AddCors() Middleware {
	return func(next http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			if !cors.AddCors(w, r) {
				log.ErrorContext(r.Context(), "Failed to add CORS headers", slog.String("origin", r.Header.Get("Origin")))
				return
			}
			next(w, r)
		}
	}
}

// Times the request handling and logs the duration
func Timer() Middleware {
	return func(next http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			lrw := &logResponseWriter{w, http.StatusOK}
			next(lrw, r)
			r = r.WithContext(logger.AppendCtx(r.Context(), slog.Int("status", lrw.statusCode)))
			log.InfoContext(r.Context(), "Request handled", slog.String("duration", time.Since(start).String()))
		}
	}
}
