import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/user/user.dart';

var mockPost1 = bsky.Post(
  likeCount: 43,
  replyCount: 12,
  record: bsky.PostRecord(
    text: 'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the '
        'printing and typesetting industry. Lorem Ipsum has been the '
        "industry's standard dummy text ever since the 1500s, when "
        'an unknown printer took a galley of type and scrambled it '
        'to make a type specimen book. It has survived not only '
        'five centuries, but also the leap into electronic ',
    facets: [
      bsky.Facet(
        index: bsky.ByteSlice(byteStart: 0, byteEnd: 20),
        features: [
          bsky.FacetFeature.tag(
            data: bsky.FacetTag(tag: 'boshi'),
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(
    did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
    handle: 'bsky.app',
  ),
  uri: AtUri('did:web:discover.bsky.app'),
  cid: 'bafyreievgu2ty7qbiaaom5zhmkznsnajuzideek3lo7e65dwqlrvrxnmo4',
  indexedAt: DateTime.now(),
);

var mockPost2 = bsky.Post(
  likeCount: 75,
  replyCount: 4,
  record: bsky.PostRecord(
    text: 'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the '
        'printing and typesetting industry. Lorem Ipsum has been the '
        "industry's standard dummy text ever since the 1500s, when "
        'an unknown printer took a galley of type and scrambled it '
        'to make a type specimen book. It has survived not only '
        'five centuries, but also the leap into electronic ',
    facets: [
      bsky.Facet(
        index: bsky.ByteSlice(byteStart: 0, byteEnd: 20),
        features: [
          bsky.FacetFeature.tag(
            data: bsky.FacetTag(tag: 'boshi'),
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(
    did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
    handle: 'bsky.app',
  ),
  uri: AtUri('did:web:discover.bsky.app'),
  cid: 'bafyreievgu2ty7qbiaaom5zhmkznsnajuzideek3lo7e65dwqlrvrxnmo5',
  indexedAt: DateTime.now(),
);

var mockPost3 = bsky.Post(
  likeCount: 85858,
  replyCount: 5830,
  record: bsky.PostRecord(
    text: 'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the '
        'printing and typesetting industry. Lorem Ipsum has been the '
        "industry's standard dummy text ever since the 1500s, when "
        'an unknown printer took a galley of type and scrambled it '
        'to make a type specimen book. It has survived not only '
        'five centuries, but also the leap into electronic ',
    facets: [
      bsky.Facet(
        index: bsky.ByteSlice(byteStart: 0, byteEnd: 20),
        features: [
          bsky.FacetFeature.tag(
            data: bsky.FacetTag(tag: 'boshi'),
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(
    did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
    handle: 'bsky.app',
  ),
  uri: AtUri('did:web:discover.bsky.app'),
  cid: 'bafyreievgu2ty7qbiaaom5zhmkznsnajuzideek3lo7e65dwqlrvrxnmoy',
  indexedAt: DateTime.now(),
);

var mockPost4 = bsky.Post(
  likeCount: 8,
  replyCount: 0,
  record: bsky.PostRecord(
    text: 'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the '
        'printing and typesetting industry. Lorem Ipsum has been the '
        "industry's standard dummy text ever since the 1500s, when "
        'an unknown printer took a galley of type and scrambled it '
        'to make a type specimen book. It has survived not only '
        'five centuries, but also the leap into electronic ',
    facets: [
      bsky.Facet(
        index: bsky.ByteSlice(byteStart: 0, byteEnd: 20),
        features: [
          bsky.FacetFeature.tag(
            data: bsky.FacetTag(tag: 'boshi'),
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(
    did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
    handle: 'bsky.app',
  ),
  uri: AtUri('did:web:discover.bsky.app'),
  cid: 'bafyreievgu2ty7qbiaaom5zhmkznsnajuzideek3lo7e65dwqlrvrxnmo7',
  indexedAt: DateTime.now(),
);

var mockPost5 = bsky.Post(
  likeCount: 32,
  replyCount: 8,
  record: bsky.PostRecord(
    text: 'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the '
        'printing and typesetting industry. Lorem Ipsum has been the '
        "industry's standard dummy text ever since the 1500s, when "
        'an unknown printer took a galley of type and scrambled it '
        'to make a type specimen book. It has survived not only '
        'five centuries, but also the leap into electronic ',
    facets: [
      bsky.Facet(
        index: bsky.ByteSlice(byteStart: 0, byteEnd: 20),
        features: [
          bsky.FacetFeature.tag(
            data: bsky.FacetTag(tag: 'boshi'),
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(
    did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
    handle: 'bsky.app',
  ),
  uri: AtUri('did:web:discover.bsky.app'),
  cid: 'bafyreievgu2ty7qbiaaom5zhmkznsnajuzideek3lo7e65dwqlrvrxnmo8',
  indexedAt: DateTime.now(),
);

var mockPost6 = bsky.Post(
  likeCount: 43,
  replyCount: 12,
  record: bsky.PostRecord(
    text: 'What is Lorem Ipsum?\nLorem Ipsum is simply dummy text of the '
        'printing and typesetting industry. Lorem Ipsum has been the '
        "industry's standard dummy text ever since the 1500s, when "
        'an unknown printer took a galley of type and scrambled it '
        'to make a type specimen book. It has survived not only '
        'five centuries, but also the leap into electronic ',
    facets: [
      bsky.Facet(
        index: bsky.ByteSlice(byteStart: 0, byteEnd: 20),
        features: [
          bsky.FacetFeature.tag(
            data: bsky.FacetTag(tag: 'boshi'),
          ),
        ],
      ),
    ],
    createdAt: DateTime.now(),
  ),
  author: bsky.ActorBasic(
    did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
    handle: 'bsky.app',
  ),
  uri: AtUri('did:web:discover.bsky.app'),
  cid: 'bafyreievgu2ty7qbiaaom5zhmkznsnajuzideek3lo7e65dwqlrvrxnmo9',
  indexedAt: DateTime.now(),
);

var mockUser = User(
  did: 'did:plc:pqlrhvmhtthnggkr6ws7mpms',
  handle: 'pensir.bsky.social',
  school: 'University of Florida',
);

var mockGetFeedResult = bsky.Feed(
  feed: List.from([
    bsky.FeedView(post: mockPost1),
    bsky.FeedView(post: mockPost2),
    bsky.FeedView(post: mockPost3),
    bsky.FeedView(post: mockPost4),
    bsky.FeedView(post: mockPost5),
    bsky.FeedView(post: mockPost6),
  ]),
);

var mockPostThreadViewRecord = bsky.PostThreadView.record(
  data: bsky.PostThreadViewRecord(
    post: mockPost,
  ),
);

var mockGetPostThreadResult = bsky.PostThread(
  thread: bsky.PostThreadView.record(
    data: bsky.PostThreadViewRecord(
      post: mockPost,
      replies: [mockPostThreadViewRecord, mockPostThreadViewRecord],
    ),
  ),
);
