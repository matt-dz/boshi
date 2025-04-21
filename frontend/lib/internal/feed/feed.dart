import 'dart:io';
import 'package:atproto/atproto.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/logger/logger.dart';

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

Future<AtUri?> retrieveLikeUri(
  ATProto atp,
  AtUri uri,
  String did, [
  String? cursor,
]) async {
  logger.d('Retriving likes');
  final response = await atp.repo.listRecords(
    repo: did,
    collection: NSID('app.bsky.feed.like'),
    cursor: cursor,
  );
  if (response.status.code > 299) {
    throw HttpException(response.status.message);
  }

  // Base case - no more records
  if (response.data.records.isEmpty) {
    logger.d('No more records');
    return null;
  }

  for (final record in response.data.records) {
    final value = record.value;
    final subject = value['subject'];
    if (subject is! Map) {
      throw Exception('Invalid value: $value');
    }
    final likedPostUri = subject['uri'] as String;
    if (likedPostUri == uri.toString()) {
      logger.d('Found record: ${record.uri}');
      return record.uri;
    }
  }

  logger.d('Searching next page');
  return retrieveLikeUri(atp, uri, did, response.data.cursor);
}
