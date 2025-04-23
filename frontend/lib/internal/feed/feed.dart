import 'dart:io';

import 'package:atproto/atproto.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/domain/models/post/post.dart';

/// Extracts the title from a post.
///
/// @param post The post to extract the title from.
/// @returns The title of the post.
String extractTitle(Post post) {
  final titleEnd = post.post.record.facets?[0].index.byteEnd;
  return post.post.record.text.substring(0, titleEnd);
}

/// Extracts the context from a post.
///
/// @param post The post to extract the context from.
/// @returns The context of the post.
String extractContext(Post post) {
  final titleEnd = post.post.record.facets?[0].index.byteEnd;
  return post.post.record.text
      .substring(titleEnd == null || titleEnd == 0 ? 0 : titleEnd + 1);
}

/// Extracts the content from a post.
///
/// @param post The post to extract the content from.
/// @returns The content of the post.
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

/// Converts a Bluesky feed to a list of domain posts.
///
/// @param feed The Bluesky feed to convert.
/// @param users The list of users to associate with the posts.
/// @returns A list of domain posts.
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


/// Retrieves the like URI for a given post.
///
/// @param atp The ATProto instance.
/// @param uri The URI of the post.
/// @param did The DID of the user.
/// @param cursor The cursor for pagination.
/// @returns The URI of the like, or null if not found.
/// @throws HttpException if the request fails.
/// @throws Exception if the response is invalid.
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

/// Retrieves the handle for a given DID.
///
/// @param bluesky The Bluesky instance.
/// @param did The DID to resolve.
/// @returns The handle associated with the DID.
/// @throws HttpException if the request fails.
Future<String> resolveHandle(bsky.Bluesky bluesky, String did) async {
  logger.d('Resolving handle for $did');
  final profile = await bluesky.actor.getProfile(actor: did);
  if (profile.status.code > 299) {
    throw HttpException(profile.status.message);
  }
  return profile.data.handle;
}
