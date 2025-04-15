import 'package:atproto/atproto_oauth.dart';
import 'package:frontend/data/services/local/local_data_service.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/utils/result.dart';
import './atproto_repository.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/shared/exceptions/oauth_unauthorized.dart';
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
      return Result.error(OAuthUnauthorized('Not authorized to create a post'));
    }
    return await _localDataService.createPost(atProto!, post);
  }

  @override
  Future<Result<void>> addVerificationEmail(String email) async {
    if (!authorized) {
      return Result.error(OAuthUnauthorized('Not authorized to verify email'));
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorized('Not authorized to verify email'));
    }

    return _localDataService.addVerificationEmail(email, userDid);
  }

  @override
  Future<Result<void>> confirmVerificationCode(
    String email,
    String code,
  ) async {
    if (!authorized) {
      return Result.error(
        OAuthUnauthorized('Not authorized to confirm verification code'),
      );
    }

    logger.d('Retrieving user DID');
    final userDid = atProto!.oAuthSession?.sub;
    if (userDid == null) {
      logger.e('User DID is null');
      return Result.error(OAuthUnauthorized('Not authorized to verify email'));
    }

    return _localDataService.confirmVerificationCode(email, code, userDid);
  }
}
