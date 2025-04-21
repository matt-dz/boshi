import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;

var mockPost = bsky.Post(
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

var mockGetFeedResult = bsky.Feed(
  feed: List.from([bsky.FeedView(post: mockPost)]),
);
