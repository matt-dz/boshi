CREATE TABLE post (
    uri VARCHAR,
    cid VARCHAR NOT NULL,
    author_did VARCHAR NOT NULL,
    indexed_at TIMESTAMPTZ NOT NULL,
    title VARCHAR(511) NOT NULL,
    content VARCHAR(8191) NOT NULL,
    reply_to_post_cid VARCHAR,
    PRIMARY KEY (uri)
);

CREATE TABLE reaction (
    uri VARCHAR,
    post_uri VARCHAR,
    author_did VARCHAR NOT NULL,
    indexed_at TIMESTAMPTZ NOT NULL,
    emote VARCHAR NOT NULL,
    PRIMARY KEY (uri),
    FOREIGN KEY (post_uri) REFERENCES post (uri)
);
