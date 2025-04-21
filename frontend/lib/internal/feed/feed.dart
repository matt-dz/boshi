import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

List<Post> convertFeedToDomainPosts(
  bsky.Feed feed,
  List<User> users,
) {
  return feed.feed
      .map((feedView) {
        final titleEnd = feedView.post.record.facets?[0].index.byteEnd;

        final title = feedView.post.record.text.substring(0, titleEnd);
        final content = feedView.post.record.text
            .substring(titleEnd == null ? 0 : titleEnd + 1);
        final user = users.where(
          (u) => u.did == feedView.post.author.did,
        );

        if (user.length != 1) {
          return null;
        }

        return Post(
          uri: feedView.post.uri,
          cid: feedView.post.cid,
          author: User(
            did: feedView.post.author.did,
            school: user.single.school,
          ),
          title: title,
          content: content,
          timestamp: feedView.post.indexedAt,
          likes: 50,
          numReplies: 10,
          likedByUser: feedView.post.isLiked,
        );
      })
      .whereType<Post>()
      .toList();
}
