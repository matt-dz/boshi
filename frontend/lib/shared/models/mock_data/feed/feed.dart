import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/reply/reply.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/domain/models/reaction/reaction.dart';

var mockPost = bsky.Post(
  record: bsky.PostRecord(
    text: "{title: 'mock title', content: 'mock content'}",
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(did: 'mockDid', handle: 'mockHandle'),
  uri: AtUri('mockUri'),
  cid: 'mockCid',
  indexedAt: DateTime.now(),
);

var mockFeedView = bsky.FeedView(post: mockPost);

var mockGetFeedResult = bsky.Feed(
  feed: List.from([mockFeedView]),
);

var mockFeed = [
  Post(
    author: User(
      id: '1',
      username: 'anonymous1',
      school: 'University of Florida',
    ),
    content: 'Hello, world!',
    timestamp: DateTime.now(),
    reactions: [
      Reaction(emote: '🔥', count: 5),
      Reaction(emote: '❤️', count: 10),
      Reaction(emote: '👍', count: 178),
    ],
    comments: [],
    id: '1',
    title: 'Post 1',
  ),
  Post(
    author: User(
      id: '2',
      username: 'anonymous2',
      school: 'Stanford University',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [
      Reaction(emote: '🥂', count: 999),
      Reaction(emote: '⚡️', count: 84),
      Reaction(emote: '🔥', count: 47),
      Reaction(emote: '❤️', count: 78),
      Reaction(emote: '👍', count: 7),
    ],
    comments: [
      Reply(
        id: '100',
        author: User(
          id: '1',
          username: 'anonymous1',
          school: 'University of Florida',
        ),
        content: 'This is a reply',
        timestamp: DateTime.now(),
        reactions: [
          Reaction(emote: '🔥', count: 4),
          Reaction(emote: '❤️', count: 79),
          Reaction(emote: '👍', count: 17),
        ],
        replyToId: '1',
        comments: [
          Reply(
            id: '101',
            author: User(
              id: '2',
              username: 'anonymous2',
              school: 'Stanford University',
            ),
            content: 'This is a reply to a reply',
            timestamp: DateTime.now(),
            reactions: [],
            replyToId: '100',
            comments: [
              Reply(
                id: '102',
                author: User(
                  id: '3',
                  username: 'anonymous3',
                  school: 'University of Washington',
                ),
                content: 'This is a reply to a reply to a reply',
                timestamp: DateTime.now(),
                reactions: [],
                replyToId: '101',
                comments: [],
              ),
            ],
          ),
          Reply(
            id: '103',
            author: User(
              id: '4',
              username: 'anonymous4',
              school: 'Princeton University',
            ),
            content: 'This is a reply to a reply',
            timestamp: DateTime.now(),
            reactions: [],
            replyToId: '100',
            comments: [
              Reply(
                id: '104',
                author: User(
                  id: '3',
                  username: 'anonymous3',
                  school: 'University of Washington',
                ),
                content: 'This is a reply to a reply to a reply',
                timestamp: DateTime.now(),
                reactions: [],
                replyToId: '103',
                comments: [],
              ),
            ],
          ),
        ],
      ),
    ],
    title: 'Post 2',
    id: '2',
  ),
  Post(
    author: User(
      id: '3',
      username: 'anonymous3',
      school: 'University of Washington',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 3',
    id: '3',
  ),
  Post(
    author: User(
      id: '4',
      username: 'anonymous4',
      school: 'Princeton University',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit , sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 4',
    id: '4',
  ),
  Post(
    author: User(
      id: '5',
      username: 'anonymous5',
      school: 'Harvard University',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 5',
    id: '5',
  ),
  Post(
    author: User(
      id: '6',
      username: 'anonymous6',
      school: 'University of California, Berkely',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 6',
    id: '6',
  ),
  Post(
    author: User(
      id: '7',
      username: 'anonymous7',
      school: 'University of Southern California',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 7',
    id: '7',
  ),
  Post(
    author: User(
      id: '8',
      username: 'anonymous8',
      school: 'University of California, Los Angeles',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 8',
    id: '8',
  ),
  Post(
    author: User(
      id: '9',
      username: 'anonymous9',
      school: 'University of Pennsylvania',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 9',
    id: '9',
  ),
  Post(
    author: User(
      id: '10',
      username: 'anonymous10',
      school: 'Massachusetts Institute of Technology',
    ),
    content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.''',
    timestamp: DateTime.now(),
    reactions: [],
    comments: [],
    title: 'Post 10',
    id: '10',
  ),
];
