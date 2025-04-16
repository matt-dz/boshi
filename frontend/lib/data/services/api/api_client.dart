import 'dart:io';
import 'dart:convert';
import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/shared/models/report/report.dart' as boshi_report;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;
import 'package:frontend/shared/models/post/post.dart' as post_request;
import 'package:http/http.dart' as http;
import 'package:frontend/shared/oauth/oauth.dart' as oauth_shared;

import 'package:frontend/shared/models/mock_data/feed/feed.dart';

import 'package:frontend/utils/logger.dart';

class ApiClient {
  ApiClient({String? host, HttpClient Function()? clientFactory})
      : _host = host ?? 'localhost',
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final HttpClient Function() _clientFactory;

  Future<Result<bsky.Feed>> getFeed(OAuthSession session) async {
    logger.d('Getting Feed');
    final bskyServer = bsky.Bluesky.fromOAuthSession(session);

    final feedGenUri = const String.fromEnvironment('FEED_GENERATOR_URI');

    if (feedGenUri == '') {
      return Result.error(
        Exception('Failed to get FEED_GENERATOR_URI env'),
      );
    }

    final generatorUri = AtUri.parse(feedGenUri);

    final xrpcResponse =
        await bskyServer.feed.getFeed(generatorUri: generatorUri);

    logger.d(xrpcResponse.data);

    if (xrpcResponse.status == HttpStatus.ok) {
      return Result.ok(xrpcResponse.data);
    } else {
      return Result.error(
        Exception(
          'Failed to get feed with status: ${xrpcResponse.status}',
        ),
      );
    }
  }

  // TODO: Implement the getUser method
  Future<Result<User>> getUser(String did) async {
    logger.f('Sending GET request for User $did');
    logger.f(_host);
    final response = await http.get(
      Uri(scheme: 'https', host: _host, path: 'user/$did'),
    );

    if (response.statusCode != 200) {
      logger.e('Failed to get user: $response');
      return Result.error(
        Exception('Failed to get user'),
      );
    }

    try {
      final User result = User.fromJson(json.decode(response.body));
      return Result.ok(result);
    } catch (error) {
      return Result.error(Exception('Failed to parse user with error $error'));
    }
  }

  Future<Result<Post>> getPost(String id) async {
    logger.d('Retrieving post');
    return Result.ok(mockFeed[0]);
  }

  Future<Result<Post>> updateReactionCount(
    ReactionPayload reactionPayload,
  ) async {
    logger.d('Updating reaction count');
    return Result.ok(mockFeed[0]);
  }

  Future<Result<Post>> addReply(reply_request.Reply reply) async {
    logger.d('Adding reply');
    return Result.ok(mockFeed[0]);
  }

  Future<Result<void>> reportPost(boshi_report.Report report) async {
    logger.d('Reporting post');
    return Result.ok(null);
  }

  Future<Result<void>> createPost(
    ATProto session,
    post_request.Post post,
  ) async {
    logger.d('Creating post');
    final xrpcResponse = await session.repo.createRecord(
      collection: NSID.create('feed.boshi.app', 'post'),
      record: {
        'title': post.title,
        'content': post.content,
        'timestamp': post.indexedAt,
      },
    );

    if (xrpcResponse.status == HttpStatus.ok) {
      return Result.ok(null);
    } else {
      return Result.error(
        Exception(
          'Failed to create post record with status: ${xrpcResponse.status}',
        ),
      );
    }
  }

  /// Sends a GET request to the Boshi backend to get
  /// the OAuth client metadata
  Future<OAuthClientMetadata> getOAuthClientMetadata(
    String clientId,
  ) async {
    logger.d('Sending GET request for OAuth client metadata');
    final response = await http.get(Uri.parse(clientId));

    if (response.statusCode != 200) {
      logger.e('Failed to get client metadata: $response');
      throw OAuthException(
        'Failed to get client metadata: ${response.statusCode}',
      );
    }

    logger.d('Decoding response');
    return OAuthClientMetadata.fromJson(jsonDecode(response.body));
  }

  Future<(Uri, OAuthContext)> getOAuthAuthorizationURI(
    OAuthClient client,
    String identity,
  ) async {
    return oauth_shared.getOAuthAuthorizationURI(client, identity);
  }

  Future<OAuthSession> generateSession(
    OAuthClient client,
    String callback,
  ) async {
    return oauth_shared.generateSession(client, callback);
  }

  Future<(OAuthSession, ATProto)> refreshSession(OAuthClient client) async {
    return oauth_shared.refreshSession(client);
  }
}
