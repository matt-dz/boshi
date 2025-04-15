package main

import (
	"boshi-explorer/internal/database"
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/sqlc"
	"context"
	"fmt"
	"math"

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

var retries = 5
var baseDelay = 100 * time.Millisecond

func init() {
	err := godotenv.Load()
	if err != nil {
		log.Info("Failed to load env -- defaulting to environment")
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

func runExplorer(workScheduler *sequential.Scheduler) {
		defer func() {
			if r := recover(); r != nil {
				log.Error("Recovered from panic: ", r)
			}
		}()

		for {
			var firehoseConnection *websocket.Conn = nil
			var err error

			log.Debug("Connecting to firehose", "uri", uri)

			for i := range retries {
				firehoseConnection, _, err = websocket.DefaultDialer.Dial(uri, http.Header{})
				if err != nil {
					log.Error("Failed to create firehose connection", "error", err.Error())
					retryPow := math.Pow(2, float64(i))
					log.Error("Retrying operation", "in (s)", retryPow / 10)
					delay := time.Duration(retryPow) * baseDelay
					time.Sleep(delay)
					continue
				} else {
					break
				}
			}

			if firehoseConnection == nil {
				break
			}

			/* Create event processor and connect it to the firehose */
			log.Debug("Starting repo stream")

			err = events.HandleRepoStream(context.Background(), firehoseConnection, workScheduler, log)
			if err != nil {
				log.Error("Failed while handling firehose stream", "error", err.Error())
			}
		}
	}
	
func main() {

	log.Debug("Connecting to postgres")
	pool := database.Connect(context.Background())
	defer pool.Close()
	queries := sqlc.New(pool)
	
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
	runExplorer(workScheduler)
}
