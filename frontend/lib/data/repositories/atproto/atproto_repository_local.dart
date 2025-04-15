import 'package:bluesky/bluesky.dart' as bsky;
import 'package:atproto/atproto_oauth.dart';
import 'package:frontend/data/services/local/local_data_service.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/exceptions/not_authorized_exception.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/domain/models/post/post.dart' as domain_models;
import 'package:frontend/shared/util/convert_feed_to_domain_posts.dart';
import 'package:frontend/utils/result.dart';
import './atproto_repository.dart';
import 'package:atproto/atproto.dart' as atp;

import 'package:frontend/utils/logger.dart';

class AtProtoRepositoryLocal extends AtProtoRepository {
  AtProtoRepositoryLocal({
    required super.clientId,
    required LocalDataService localDataService,
  }) : _localDataService = localDataService;

  final LocalDataService _localDataService;

  void _initializeOAuthClient() {
    clientMetadata ??= OAuthClientMetadata(
      clientId: '${clientId.scheme}://${clientId.host}',
      clientName: 'Boshi',
      clientUri: clientId.toString(),
      redirectUris: ['http://127.0.0.1:${clientId.port}'],
      grantTypes: ['authorization_code', 'refresh_token'],
      scope: 'atproto',
      responseTypes: ['code'],
      applicationType: 'web',
      tokenEndpointAuthMethod: 'none',
    );
    oAuthClient ??= OAuthClient(clientMetadata!, service: service);
    initialized = true;
    logger.d(clientMetadata);
  }

  @override
  Future<Result<Uri>> getAuthorizationURI(
    String identity,
    String service,
  ) async {
    try {
      this.identity = identity;
      this.service = service;
      _initializeOAuthClient();
      final (uri, context) = await _localDataService.getOAuthAuthorizationURI(
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
      _initializeOAuthClient();
      final session =
          await _localDataService.generateSession(oAuthClient!, callback);
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
      _initializeOAuthClient();
      final (_, newAtproto) =
          await _localDataService.refreshSession(oAuthClient!);
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
    if (authorized) {
      return await _localDataService.createPost(atProto!, post);
    } else {
      return Result.error(NotAuthorizedException('createPost'));
    }
  }

  @override
  Future<Result<List<domain_models.Post>>> getFeed() async {
    if (authorized) {
      final bskyFeed = _localDataService.getFeed();

      switch (bskyFeed) {
        case Ok<bsky.Feed>():
          return Result.ok(convertFeedToDomainPosts(bskyFeed.value));
        case Error<bsky.Feed>():
          return Result.error(bskyFeed.error);
      }
    } else {
      return Result.error(NotAuthorizedException('getFeed'));
    }
  }

  @override
  Future<Result<User>> getUser(String did) async {
    return _localDataService.getUser();
  }
}
