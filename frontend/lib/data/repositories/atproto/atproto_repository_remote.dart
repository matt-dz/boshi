import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/exceptions/unauthorized_exception.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/domain/models/post/post.dart' as domain_models;
import 'package:frontend/internal/feed/feed.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/data/services/api/api_client.dart';
import './atproto_repository.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;

class AtProtoRepositoryRemote extends AtProtoRepository {
  AtProtoRepositoryRemote({
    required super.clientId,
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  Future<void> _initializeOAuthClient() async {
    clientMetadata ??=
        await _apiClient.getOAuthClientMetadata(clientId.toString());
    oAuthClient ??= OAuthClient(clientMetadata!, service: service);
    initialized = true;
  }

  @override
  Future<Result<Uri>> getAuthorizationURI(
    String identity,
    String service,
  ) async {
    try {
      this.identity = identity;
      this.service = service;
      await _initializeOAuthClient();
      final (uri, context) = await _apiClient.getOAuthAuthorizationURI(
        oAuthClient!,
        identity,
      );
      oAuthContext = context;
      return Result.ok(uri);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> generateSession(String callback) async {
    try {
      await _initializeOAuthClient();
      final session = await _apiClient.generateSession(oAuthClient!, callback);
      atProto = atp.ATProto.fromOAuthSession(session);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> refreshSession() async {
    try {
      await _initializeOAuthClient();
      final (_, newAtproto) = await _apiClient.refreshSession(oAuthClient!);
      atProto = newAtproto;
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> createPost(Post post) async {
    if (!authorized) {
      return Result.error(UnauthorizedException('createPost'));
    }
    return await _apiClient.createPost(atProto!, post);
  }

  @override
  Future<Result<List<domain_models.Post>>> getFeed() async {
    if (!authorized) {
      return Result.error(UnauthorizedException('getFeed'));
    }
    final bskyFeed = await _apiClient.getFeed(atProto!.oAuthSession!);

    switch (bskyFeed) {
      case Ok<bsky.Feed>():
        return Result.ok(convertFeedToDomainPosts(bskyFeed.value));
      case Error<bsky.Feed>():
        return Result.error(bskyFeed.error);
    }
  }

  @override
  Future<Result<User>> getUser(String did) async {
    return await _apiClient.getUser(did);
  }
}
