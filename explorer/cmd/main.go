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
	"github.com/joho/godotenv"
)

var log = logger.GetLogger()

var uri string
var firehoseIdentifier string

func init() {
	err := godotenv.Load()
	if err != nil {
		panic("Failed to load env")
	}

	uri = os.Getenv("SOCKET_URI")
	if uri == "" {
		panic("Expected SOCKET_URI to be set")
	}

	firehoseIdentifier = os.Getenv("FIREHOSE_IDENTIFIER")
	if firehoseIdentifier == "" {
		panic("Expected FIREHOSE_IDENTIFIER to be set")
	}
}

func runExplorer(repoCallbacks *events.RepoStreamCallbacks) {
		defer func() {
			if r := recover(); r != nil {
				log.Error("Recovered from panic: ", r)
			}
		}()

		log.Debug("Connecting to firehose", "uri", uri)

		firehoseConnection, _, err := websocket.DefaultDialer.Dial(uri, http.Header{})
		if err != nil {
			log.Error("Failed to create firehose connection", "error", err.Error())
		}
		
		workScheduler := sequential.NewScheduler(firehoseIdentifier, repoCallbacks.EventHandler)
		err = events.HandleRepoStream(context.Background(), firehoseConnection, workScheduler, log)
		if err != nil {
			log.Error("Failed while handling firehose stream", "error", err.Error())
		}
}

func main() {
	
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

	for {
		runExplorer(repoCallbacks)
	}
}
