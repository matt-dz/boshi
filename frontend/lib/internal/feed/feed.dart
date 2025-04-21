import 'dart:io';
import 'dart:convert';
import 'package:atproto/atproto.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/internal/result/result.dart';

String extractTitle(Post post) {
  final titleEnd = post.post.record.facets?[0].index.byteEnd;
  return post.post.record.text.substring(0, titleEnd);
}

String extractContext(Post post) {
  final titleEnd = post.post.record.facets?[0].index.byteEnd;
  return post.post.record.text.substring(titleEnd == null ? 0 : titleEnd + 1);
}

String timeSincePosting(Post post) {
  final currentTime = DateTime.now().toUtc();
  final timeDifference = currentTime.difference(post.post.indexedAt.toUtc());

  if (timeDifference.inDays >= 7) {
    return '${timeDifference.inDays ~/ 7}w';
  } else if (timeDifference.inDays >= 1) {
    return '${timeDifference.inDays}d';
  } else if (timeDifference.inHours >= 1) {
    return '${timeDifference.inHours}h';
  } else if (timeDifference.inMinutes >= 1) {
    return '${timeDifference.inMinutes}m';
  } else {
    return '${timeDifference.inSeconds}s';
  }
}

List<Post> convertFeedToDomainPosts(
  bsky.Feed feed,
  List<User> users,
) {
  return feed.feed
      .map((feedView) {
        final user = users.where(
          (u) => u.did == feedView.post.author.did,
        );

        if (user.length != 1) {
          return null;
        }
        return Post(
          bskyPost: feedView.post,
          author: User(
            did: feedView.post.author.did,
            school: user.single.school,
            handle: user.single.handle,
          ),
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

Future<String> resolveHandle(ATProto atp, String did) async {
  logger.d('Resolving handle for $did');
  final repo = await atp.repo.describeRepo(repo: did);
  if (repo.status.code > 299) {
    throw HttpException(
      'Failed to get user repo with status: ${repo.status.code}',
    );
  }

  final aka = repo.data.didDoc['alsoKnownAs'];
  if (aka is! List) {
    throw HttpException('Invalid alsoKnownAs format: $aka');
  }
  if (aka.isEmpty) {
    throw HttpException('No alsoKnownAs found');
  }
  logger.d('Resolved handle to ${aka.first}');

  return aka.first as String;
}
