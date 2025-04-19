package main

import (
	"boshi-explorer/internal/database"
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/payloads"
	"boshi-explorer/internal/sqlc"
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"math"

	"net/http"
	"net/url"
	"os"
	"strings"
	"time"

	"github.com/bluesky-social/indigo/api/atproto"
	"github.com/bluesky-social/indigo/atproto/identity"
	"github.com/bluesky-social/indigo/atproto/syntax"
	"github.com/bluesky-social/indigo/events"
	"github.com/bluesky-social/indigo/events/schedulers/sequential"
	"github.com/gorilla/websocket"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/joho/godotenv"
)

var log = logger.GetLogger()

var uri string
var firehoseIdentifier string

const retries = 5
const baseDelay = 100 * time.Millisecond

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
	for {
		var firehoseConnection *websocket.Conn = nil
		var err error

		log.Debug("Connecting to firehose", "uri", uri)

		for i := range retries {
			firehoseConnection, _, err = websocket.DefaultDialer.Dial(uri, http.Header{})
			if err != nil {
				delay := time.Duration(math.Pow(2, float64(i))) * baseDelay
				log.Error("WebSocket retry", slog.Int("attempt", i+1), slog.Any("waiting", delay), slog.Any("error", err))
				time.Sleep(delay)
				continue
			} else {
				break
			}
		}

		if firehoseConnection == nil {
			log.Error("Failed to establish a connection -- killing explorer.")
			break
		}

		/* Create event processor and connect it to the firehose */
		log.Debug("Starting repo stream")

		err = events.HandleRepoStream(context.Background(), firehoseConnection, workScheduler, log)
		if err != nil {
			log.Error("Failed while handling firehose stream", slog.Any("error", err))
		}
	}
}

func getRecord(evt *atproto.SyncSubscribeRepos_Commit, op *atproto.SyncSubscribeRepos_RepoOp) (payloads.Record, time.Time, error) {
	did, err := syntax.ParseDID(evt.Repo)
	if err != nil {
		log.Error("Failed to parse did", "did", evt.Repo)
		return payloads.Record{}, time.Now(), err
	}

	didDoc, err := identity.DefaultDirectory().LookupDID(context.Background(), did)
	if err != nil {
		log.Error("Failed to lookup did", "did", did.AtIdentifier())
		return payloads.Record{}, time.Now(), err
	}

	log.Debug("helpme", slog.Any("doc", didDoc))

	atprotoPDS := didDoc.Services["#atproto_pds"].URL
	apiURL := fmt.Sprintf("%s/xrpc/com.atproto.repo.getRecord", atprotoPDS)

	params := url.Values{}
	params.Add("repo", evt.Repo)
	params.Add("collection", "app.boshi.feed.post")
	splitPath := strings.Split(op.Path, "/")
	params.Add("rkey", splitPath[len(splitPath)-1])

	fullUrl := fmt.Sprintf("%s?%s", apiURL, params.Encode())

	resp, err := http.Get(fullUrl)
	if err != nil {
		log.Error("Failed to get record", slog.Any("error", err))
		return payloads.Record{}, time.Now(), err
	}
	defer resp.Body.Close()

	var record payloads.Record
	if err := json.NewDecoder(resp.Body).Decode(&record); err != nil {
		log.Error("Failed to parse record response", slog.Any("error", err))
		return payloads.Record{}, time.Now(), err
	}

	indexedTime, err := time.Parse("2006-01-02 15:04:05.000", record.Value.Timestamp)
	if err != nil {
		log.Error("Failed to parse time", slog.Any("error", err))
		return record, time.Now(), err
	}

	return record, indexedTime, err
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
					log.Info("New Activity @", slog.String("uri", uri))

					record, indexedTime, err := getRecord(evt, op)
					if err != nil {
						log.Error("Failed to get record", slog.Any("error", err))
					}

					post := sqlc.CreatePostParams{
						Uri:       uri,
						Cid:       op.Cid.String(),
						AuthorDid: evt.Repo,
						Title:     record.Value.Title,
						Content:   record.Value.Content,
						IndexedAt: pgtype.Timestamptz{Time: indexedTime, Valid: true},
					}

					queries.CreatePost(context.Background(), post)

					log.Info("Post created", slog.String("uri", uri), slog.Any("post", post))
				}
			}
			return nil
		},
	}

	workScheduler := sequential.NewScheduler(firehoseIdentifier, repoCallbacks.EventHandler)
	runExplorer(workScheduler)
}
