import 'package:atproto/atproto.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/logger/logger.dart';

StrongRef getRootFromPostThread(bsky.PostThreadViewRecord post) {
  logger.d(post.parent);
  return post.parent == null
      ? StrongRef(cid: post.post.cid, uri: post.post.uri)
      : post.parent!.maybeWhen(
          record: (parent) => getRootFromPostThread(parent),
          orElse: () => StrongRef(cid: post.post.cid, uri: post.post.uri),
        );
}

void extractDidsFromPostThread(
  bsky.PostThreadViewRecord postThread,
  Set<String> dids,
) {
  dids.add(postThread.post.author.did);

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
  final replies = List<Post>.empty(growable: true);

  if (replyRecords == null) {
    return replies;
  }

  for (final reply in replyRecords) {
    reply.whenOrNull(
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
      },
    );
  }

  return replies;
}
