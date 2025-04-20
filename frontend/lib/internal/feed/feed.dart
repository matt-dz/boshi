import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

List<Post> convertFeedToDomainPosts(bsky.Feed feed) {
  return feed.feed
      .map(
        (feedView) => Post(
          id: feedView.post.cid,
          author: User(
            id: feedView.post.author.did,
            school: '',
            verifiedAt: DateTime.now(),
          ),
          content: feedView.post.record.text,
          timestamp: feedView.post.indexedAt,
          reactions: List.empty(),
          comments: List.empty(),
          title: feedView.post.record.text,
        ),
      )
      .toList();
}
