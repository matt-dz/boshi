CREATE TABLE post (
    uri VARCHAR,
    cid VARCHAR NOT NULL,
    author_did VARCHAR NOT NULL,
    indexed_at TIMESTAMPTZ NOT NULL,
    title VARCHAR(511) NOT NULL,
    content VARCHAR(8191) NOT NULL,
    PRIMARY KEY (uri)
);

CREATE TABLE reply (
    uri VARCHAR,
    cid VARCHAR NOT NULL,
    author_did VARCHAR NOT NULL,
    indexed_at TIMESTAMPTZ NOT NULL,
    title VARCHAR(511) NOT NULL,
    content VARCHAR(8191) NOT NULL,
    reply_to_uri VARCHAR NOT NULL,
    PRIMARY KEY (uri),
    FOREIGN KEY (reply_to_uri) REFERENCES post (uri) ON DELETE CASCADE
);

CREATE TABLE reaction (
    uri VARCHAR,
    post_uri VARCHAR,
    author_did VARCHAR NOT NULL,
    indexed_at TIMESTAMPTZ NOT NULL,
    emote VARCHAR NOT NULL,
    PRIMARY KEY (uri),
    FOREIGN KEY (post_uri) REFERENCES post (uri) ON DELETE CASCADE
);

CREATE TABLE mail_list (
    email VARCHAR NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    PRIMARY KEY (email)
);

CREATE TABLE emails (
    user_id VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW (),
    verified_at TIMESTAMPTZ,
    PRIMARY KEY (user_id),
    UNIQUE (email)
);
