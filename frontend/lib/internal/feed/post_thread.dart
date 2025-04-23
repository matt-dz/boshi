import 'package:atproto/atproto.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';


/// Retrieves the root post from a given post thread.
///
/// @param post The post thread to retrieve the root from.
/// @returns The root post as a StrongRef object.
StrongRef getRootFromPostThread(bsky.PostThreadViewRecord post) {
  return post.parent == null
      ? StrongRef(cid: post.post.cid, uri: post.post.uri)
      : post.parent!.maybeWhen(
          record: (parent) => getRootFromPostThread(parent),
          orElse: () => StrongRef(cid: post.post.cid, uri: post.post.uri),
        );
}

/// Extracts the DIDs from a given post thread.
///
/// @param postThread The post thread to extract DIDs from.
/// @param dids The set of DIDs to populate.
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

/// Extracts the replies from a given post thread.
///
/// @param parent The parent post reference.
/// @param root The root post reference.
/// @param replyRecords The list of reply records.
/// @param users The list of users to associate with the replies.
/// @returns A list of Post objects representing the replies.
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
