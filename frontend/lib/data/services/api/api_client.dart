import 'dart:io';
import 'dart:convert';
import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/config/environment.dart';
import 'package:frontend/shared/exceptions/missing_env.dart';
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

  Future<Result<bsky.Feed>> getFeed(bsky.Bluesky bluesky) async {
    logger.d('Getting Feed');

    if (EnvironmentConfig.feedGenUri == '') {
      return Result.error(
        MissingEnvException('FEED_GENERATOR_URI'),
      );
    }

    final generatorUri = AtUri.parse(EnvironmentConfig.feedGenUri);

    final xrpcResponse = await bluesky.feed.getFeed(generatorUri: generatorUri);

    logger.d(xrpcResponse.data);

    if (xrpcResponse.status != HttpStatus.ok) {
      return Result.error(
        Exception(
          'Failed to get feed with status: ${xrpcResponse.status}',
        ),
      );
    }

    return Result.ok(xrpcResponse.data);
  }

  // TODO: Implement the getUser method
  Future<Result<User>> getUser() async {
    logger.w('Function not implemented. Returning default user.');
    return Result.ok(
      User(id: '1', username: 'anonymous1', school: 'University of Florida'),
    );
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
    bsky.Bluesky bluesky,
    post_request.Post post,
  ) async {
    logger.d('Creating post');
    final xrpcResponse = await bluesky.feed.post(
      text: '${post.title}\n${post.content}',
      tags: List.from(['boshi.post']),
      facets: [
        bsky.Facet(
          index: bsky.ByteSlice(byteStart: 0, byteEnd: post.title.length),
          features: [bsky.FacetFeature.tag(data: bsky.FacetTag(tag: 'boshi'))],
        ),
      ],
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
