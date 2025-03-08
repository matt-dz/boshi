-- TODO: refactor "indexedAt" to be a timestamp
CREATE TABLE post (
    uri VARCHAR PRIMARY KEY,
    cid VARCHAR NOT NULL,
    "indexedAt" VARCHAR NOT NULL
);
