import 'package:atproto/atproto.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

void extractDidsFromPostThread(
  bsky.PostThreadViewRecord postThread,
  List<String> dids,
) {
  dids.add(postThread.post.uri.toString());

  postThread.replies?.forEach(
    (reply) => reply.whenOrNull(
      record: (replyPost) => extractDidsFromPostThread(replyPost, dids),
    ),
  );
}

List<Post> extractRepliesFromPostThread(
  StrongRef parent,
  StrongRef root,
  List<bsky.PostThreadView>? replyRecords,
  List<User> users,
) {
  final replies = List<Post>.empty();

  if (replyRecords == null) {
    return replies;
  }

  replyRecords.forEach(
    (reply) => reply.whenOrNull(
      record: (replyRecord) {
        final newPost = Post(
          author: users
              .firstWhere((user) => user.did == replyRecord.post.author.did),
          bskyPost: replyRecord.post,
          parent: parent,
          root: root,
          replies: extractRepliesFromPostThread(
            StrongRef(cid: replyRecord.post.cid, uri: replyRecord.post.uri),
            root,
            replyRecord.replies,
            users,
          ),
        );
        replies.add(newPost);
        return;
      },
    ),
  );

  return replies;
}
