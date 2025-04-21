import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/foundation.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/exceptions/oauth_unauthorized_exception.dart';
import 'package:frontend/internal/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/internal/exceptions/user_not_found_exception.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/domain/models/post/post.dart' as domain_models;
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/feed/feed.dart';
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';
import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;

class AtProtoRepository extends ChangeNotifier {
  AtProtoRepository({
    required Uri clientId,
    required ApiClient apiClient,
    required bool local,
  })  : _apiClient = apiClient,
        _clientId = clientId,
        _local = local,
        clientMetadata = null,
        oAuthClient = null,
        service = 'bsky.social',
        initialized = false;

  String service;
  bool initialized;
  final Uri _clientId;
  final ApiClient _apiClient;
  final bool _local;
  late OAuthContext oAuthContext;
  atp.ATProto? atProto;
  bsky.Bluesky? bluesky;

  late OAuthClientMetadata? clientMetadata;
  late OAuthClient? oAuthClient;

  Uri get clientId => _clientId;
  bool get authorized => atProto != null;

  Future<void> _initializeOAuthClient() async {
    if (_local) {
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
      return;
    }
    clientMetadata ??=
        await _apiClient.getOAuthClientMetadata(clientId.toString());
    oAuthClient ??= OAuthClient(clientMetadata!, service: service);
    initialized = true;
  }

  Future<Result<Uri>> getAuthorizationURI(
    String identity,
    String service,
  ) async {
    try {
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

  Future<Result<void>> generateSession(String callback) async {
    try {
      await _initializeOAuthClient();
      final session = await _apiClient.generateSession(oAuthClient!, callback);
      atProto = atp.ATProto.fromOAuthSession(session);
      bluesky = bsky.Bluesky.fromOAuthSession(session);
      return Result.ok(null);
    } on Exception catch (e) {
      logger.e('Error generating session: $e');
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> refreshSession() async {
    try {
      await _initializeOAuthClient();
      final (_, newAtproto) = await _apiClient.refreshSession(oAuthClient!);
      atProto = newAtproto;
      bluesky = bsky.Bluesky.fromOAuthSession(newAtproto.oAuthSession!);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> createPost(Post post) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException('createPost'));
    }
    return await _apiClient.createPost(bluesky!, post);
  }

  Future<Result<void>> addVerificationEmail(String email) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    final result = await _apiClient.addVerificationEmail(email, userDid);
    if (result is Error<void> &&
        result.error is VerificationCodeAlreadySetException) {
      logger.d('Verification code already set. Ignoring error.');
      return Result.ok(null);
    }
    return result;
  }

  Future<Result<void>> confirmVerificationCode(
    String email,
    String code,
  ) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    return await _apiClient.confirmVerificationCode(
      email,
      code,
      userDid,
    );
  }

  Future<Result<bool>> isUserVerified() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    final result = await _apiClient.isUserVerified(userDid);
    switch (result) {
      case Ok<VerificationStatus>():
        return Result.ok(result.value.verified);
      case Error<VerificationStatus>():
        if (result.error is UserNotFoundException) {
          return Result.ok(false); // User not found, they aren't verified
        }
        return Result.error(result.error);
    }
  }

  Future<Result<double>> getVerificationCodeTTL() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorizedException());
    }

    final ttlResult = await _apiClient.getVerificationCodeTTL(userDid);
    switch (ttlResult) {
      case Ok<VerificationCodeTTL>():
        return Result.ok(ttlResult.value.ttl);
      case Error<VerificationCodeTTL>():
        return Result.error(ttlResult.error);
    }
  }

  Future<Result<List<domain_models.Post>>> getFeed() async {
    if (!authorized || bluesky == null) {
      return Result.error(OAuthUnauthorizedException());
    }

    logger.d('Retrieving feed');
    final bskyFeed = await _apiClient.getFeed(bluesky!);
    if (bskyFeed is Error) {
      return Result.error((bskyFeed as Error).error);
    }

    logger.d('Retrieving users');
    final feed = (bskyFeed as Ok).value as bsky.Feed;
    final userDids =
        feed.feed.map((post) => post.post.author.did).toSet().toList();
    final response = await _apiClient.getUsers(atProto!, userDids);
    if (response is Error) {
      return Result.error((response as Error).error);
    }

    return Result.ok(
      convertFeedToDomainPosts(
        feed,
        (response as Ok<List<User>>).value,
      ),
    );
  }

  Future<Result<List<User>>> getUsers(List<String> dids) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException('getUsers'));
    }
    final usersResult = await _apiClient.getUsers(atProto!, dids);
    return usersResult;
  }

  Future<Result<User>> getUser() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorizedException());
    }

    final String? userDid = atProto!.oAuthSession?.sub;

    if (userDid == null) {
      return Result.error(OAuthUnauthorizedException());
    }
    final userResult = await _apiClient.getUser(atProto!, userDid);

    switch (userResult) {
      case Ok<User>():
        return userResult;
      case Error<User>():
        return userResult;
    }
  }

  Future<Result<AtUri>> addLike(
    AtUri uri,
    String cid,
  ) async {
    if (!authorized || bluesky == null) {
      return Result.error(OAuthUnauthorizedException());
    }

    try {
      logger.d('Adding like');
      return await _apiClient.addLike(
        bluesky!,
        cid,
        uri,
      );
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> removeLike(
    AtUri uri,
    String cid,
    String did,
  ) async {
    if (!authorized || bluesky == null) {
      return Result.error(OAuthUnauthorizedException());
    }
    try {
      logger.d('Removing like');
      return await _apiClient.removeLike(
        atProto!,
        bluesky!,
        uri,
        did,
      );
    } on Exception catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
