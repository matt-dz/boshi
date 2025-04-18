import 'package:atproto/atproto_oauth.dart';
import 'package:frontend/data/services/local/local_data_service.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/utils/result.dart';
import './atproto_repository.dart';
import 'package:frontend/shared/exceptions/oauth_unauthorized_exception.dart';
import 'package:atproto/atproto.dart' as atp;
import 'package:frontend/data/models/responses/verification_status/verification_status.dart';
import 'package:frontend/shared/exceptions/verification_code_already_set_exception.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/data/models/responses/verification_code_ttl/verification_code_ttl.dart';

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
    if (!authorized) {
      return Result.error(OAuthUnauthorized());
    }
    return await _localDataService.createPost(atProto!, post);
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
      return Result.error(OAuthUnauthorized('Not authorized to verify email'));
    }

    final result = await _localDataService.addVerificationEmail(email, userDid);
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
      return Result.error(OAuthUnauthorized('Not authorized to verify email'));
    }

    return await _localDataService.confirmVerificationCode(
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
      return Result.error(OAuthUnauthorized('Not authorized to verify email'));
    }

    final result = await _localDataService.isUserVerified(userDid);
    switch (result) {
      case Ok<VerificationStatus>():
        return Result.ok(result.value.verified);
      case Error<VerificationStatus>():
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

    final ttlResult = await _localDataService.getVerificationCodeTTL(userDid);
    switch (ttlResult) {
      case Ok<VerificationCodeTTL>():
        return Result.ok(ttlResult.value.ttl);
      case Error<VerificationCodeTTL>():
        return Result.error(ttlResult.error);
    }
  }
}
