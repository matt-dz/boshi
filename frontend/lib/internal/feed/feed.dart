import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

List<Post> convertFeedToDomainPosts(bsky.Feed feed) {
  return feed.feed.map((feedView) {
    final titleEnd = feedView.post.record.facets?[0].index.byteEnd;

    final title = feedView.post.record.text.substring(0, titleEnd);
    final content = feedView.post.record.text
        .substring(titleEnd == null ? 0 : titleEnd + 1);

    return Post(
      id: feedView.post.cid,
      author: User(
        id: feedView.post.author.did,
        username: feedView.post.author.handle,
        school: '',
      ),
      title: title,
      content: content,
      timestamp: feedView.post.indexedAt,
      reactions: List.empty(),
      comments: List.empty(),
    );
  }).toList();
}
