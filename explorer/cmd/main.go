package main

import (
	"boshi-explorer/internal/database"
	"boshi-explorer/internal/logger"
	"boshi-explorer/sql/dbutil"
	"context"
	"fmt"
	"log/slog"

	"net/http"
	"os"
	"strings"
	"time"

	"github.com/bluesky-social/indigo/api/atproto"
	"github.com/bluesky-social/indigo/events"
	"github.com/bluesky-social/indigo/events/schedulers/sequential"
	"github.com/gorilla/websocket"
	"github.com/joho/godotenv"
)

var log = logger.GetLogger()

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		panic("Failed to load env")
	}

	uri := os.Getenv("SOCKET_URI")
	if uri == "" {
		panic("Expected SOCKET_URI to be set")
	}

	con, _, err := websocket.DefaultDialer.Dial(uri, http.Header{})
	if err != nil {
		panic(err)
	}

	pool := database.Connect(context.Background())
	defer pool.Close()
	queries := dbutil.New(pool)

	rsc := &events.RepoStreamCallbacks{
		RepoCommit: func(evt *atproto.SyncSubscribeRepos_Commit) error {
			for _, op := range evt.Ops {
				if strings.HasPrefix(op.Path, "app.boshi.feed") {
					uri := fmt.Sprintf("at://%s/%s", evt.Repo, op.Path)
					log.Info("New Activity @", "uri", uri)
					queries.CreatePost(context.Background(), dbutil.CreatePostParams{Uri: uri, Cid: op.Cid.String(), IndexedAt: time.Now().String()})
					log.Info("Post created", "uri", uri)
				}
			}
			return nil
		},
	}

	sched := sequential.NewScheduler("myfirehose", rsc.EventHandler)
	events.HandleRepoStream(context.Background(), con, sched, &slog.Logger{})
}
