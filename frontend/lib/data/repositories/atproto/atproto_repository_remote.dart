import 'package:bluesky/bluesky.dart' as bsky;
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/domain/models/post/post.dart' as domain_models;
import 'package:frontend/internal/feed/feed.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/shared/exceptions/user_not_found_exception.dart';
import 'package:frontend/shared/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/shared/exceptions/oauth_unauthorized_exception.dart';
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import './atproto_repository.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;
import 'package:frontend/utils/logger.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';

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
      return Result.error(OAuthException('createPost'));
    }
    return await _apiClient.createPost(atProto!, post);
  }

  @override
  Future<Result<List<domain_models.Post>>> getFeed() async {
    if (!authorized) {
      return Result.error(OAuthException('getFeed'));
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
  Future<Result<void>> addVerificationEmail(String email) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorized());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorized());
    }

    final result = await _apiClient.addVerificationEmail(email, userDid);
    if (result is Error<void> &&
        result.error is VerificationCodeAlreadySetException) {
      logger.d('Verification code already set. Ignoring error.');
      return Result.ok(null);
    }
    return result;
  }

  @override
  Future<Result<void>> confirmVerificationCode(
    String email,
    String code,
  ) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorized());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorized());
    }

    return await _apiClient.confirmVerificationCode(
      email,
      code,
      userDid,
    );
  }

  @override
  Future<Result<bool>> isUserVerified() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorized());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorized());
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

  @override
  Future<Result<double>> getVerificationCodeTTL() async {
    if (!authorized) {
      return Result.error(OAuthUnauthorized());
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorized());
    }

    final ttlResult = await _apiClient.getVerificationCodeTTL(userDid);
    switch (ttlResult) {
      case Ok<VerificationCodeTTL>():
        return Result.ok(ttlResult.value.ttl);
      case Error<VerificationCodeTTL>():
        return Result.error(ttlResult.error);
    }
  }
}
