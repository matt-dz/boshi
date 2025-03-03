package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"strings"

	"github.com/bluesky-social/indigo/api/atproto"
	"github.com/bluesky-social/indigo/events"
	"github.com/bluesky-social/indigo/events/schedulers/sequential"
	"github.com/gorilla/websocket"
)

func main() {
	uri := os.Getenv("SOCKET_URI"); if uri == "" {
		panic("Please define a websocket uri in your .env file")
	}
	con, _, err := websocket.DefaultDialer.Dial(uri, http.Header{}); if err != nil {
    panic(err)
  }

	rsc := &events.RepoStreamCallbacks{
		RepoCommit: func(evt *atproto.SyncSubscribeRepos_Commit) error {
      for _, op := range evt.Ops {
        if strings.HasPrefix(op.Path, "app.boshi.feed") {
					slog.Debug("Event from", "repo", evt.Repo, "action", op.Action, "path", op.Path)
        }
			}
			return nil
		},
	}

	sched := sequential.NewScheduler("myfirehose", rsc.EventHandler)
	events.HandleRepoStream(context.Background(), con, sched, &slog.Logger{})
}