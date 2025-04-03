package middleware

import (
	"boshi-backend/internal/cors"
	"boshi-backend/internal/logger"
	"context"
	"log/slog"
	"net/http"
	"time"
)

var log = logger.GetLogger()
var ctx = context.Background()

type logResponseWriter struct {
	http.ResponseWriter
	statusCode int
}

func (lrw *logResponseWriter) WriteHeader(code int) {
	lrw.statusCode = code
	lrw.ResponseWriter.WriteHeader(code)
}

type Middleware func(http.HandlerFunc) http.HandlerFunc

/*
Chain adds middleware in a chained fashion to the HTTP handler.
The middleware is applied in the order in which it is passed.
*/
func Chain(h http.HandlerFunc, m ...Middleware) http.HandlerFunc {

	// Applied in reverse to preserve the order
	for i := len(m) - 1; i >= 0; i-- {
		h = m[i](h.ServeHTTP)
	}

	return h
}

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

func AddCors() Middleware {
	return func(next http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			if cors.AddCors(w, r) {
				next(w, r)
			}
			log.ErrorContext(r.Context(), "Failed to add CORS headers", slog.String("origin", r.Header.Get("Origin")))
		}
	}
}

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
