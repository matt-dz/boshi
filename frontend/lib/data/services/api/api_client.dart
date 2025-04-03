import 'dart:io';
import 'dart:convert';
import 'package:atproto/atproto.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/shared/models/report/report.dart' as boshi_report;
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/data/models/requests/reply/reply.dart'
    as reply_request;
import 'package:frontend/data/models/requests/post/post.dart' as post_request;
import 'package:http/http.dart' as http;
import 'package:frontend/shared/oauth/oauth.dart' as oauth_shared;

import 'package:frontend/shared/models/mock_data/feed/feed.dart';

import 'package:frontend/utils/logger.dart';

class ApiClient {
  ApiClient({String? host, int? port, HttpClient Function()? clientFactory})
      : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  // TODO: Implement the getFeed method
  Future<Result<List<Post>>> getFeed() async {
    logger.w('Function not implemented. Returning default list.');
    return Result.ok(mockFeed);
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

  Future<Result<Post>> addPost(post_request.Post post) async {
    logger.d('Adding post');
    return Result.ok(mockFeed[0]);
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
