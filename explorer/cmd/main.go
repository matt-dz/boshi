package main

import (
	"boshi-explorer/internal/database"
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/sqlc"
	"context"
	"fmt"

	"net/http"
	"os"
	"strings"
	"time"

	"github.com/bluesky-social/indigo/api/atproto"
	"github.com/bluesky-social/indigo/events"
	"github.com/bluesky-social/indigo/events/schedulers/sequential"
	"github.com/gorilla/websocket"
	"github.com/jackc/pgx/v5/pgtype"
)

var log = logger.GetLogger()

var uri string
var firehoseIdentifier string

func init() {
	uri = os.Getenv("SOCKET_URI")
	if uri == "" {
		panic("Expected SOCKET_URI to be set")
	}

	firehoseIdentifier = os.Getenv("FIREHOSE_IDENTIFIER")
	if firehoseIdentifier == "" {
		panic("Expected FIREHOSE_IDENTIFIER to be set")
	}
}

func main() {
	log.Debug("Connecting to firehose", "uri", uri)
	firehoseConnection, _, err := websocket.DefaultDialer.Dial(uri, http.Header{})
	if err != nil {
		panic(err)
	}

	log.Debug("Connecting to postgres")
	pool := database.Connect(context.Background())
	defer pool.Close()
	queries := sqlc.New(pool)

	/* Create event processor and connect it to the firehose */
	log.Debug("Starting repo stream")

	repoCallbacks := &events.RepoStreamCallbacks{
		RepoCommit: func(evt *atproto.SyncSubscribeRepos_Commit) error {
			for _, op := range evt.Ops {
				if strings.HasPrefix(op.Path, "app.boshi.feed") {
					uri := fmt.Sprintf("at://%s/%s", evt.Repo, op.Path)
					log.Info("New Activity @", "uri", uri)
					queries.CreatePost(context.Background(), sqlc.CreatePostParams{Uri: uri, Cid: op.Cid.String(), AuthorDid: evt.Repo, IndexedAt: pgtype.Timestamptz{
						Time:  time.Now(),
						Valid: true,
					}})
					log.Info("Post created", "uri", uri)
				}
			}
			return nil
		},
	}

	workScheduler := sequential.NewScheduler(firehoseIdentifier, repoCallbacks.EventHandler)
	err = events.HandleRepoStream(context.Background(), firehoseConnection, workScheduler, log)
	if err != nil {
		panic(err)
	}
}
