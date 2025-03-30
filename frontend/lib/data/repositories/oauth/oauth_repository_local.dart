import 'package:atproto/atproto_oauth.dart';
import 'package:frontend/data/services/local/local_data_service.dart';
import 'package:frontend/utils/result.dart';
import 'oauth_repository.dart';
import 'package:atproto/atproto.dart' as atp;

import 'package:frontend/utils/logger.dart';

class OAuthRepositoryLocal extends OAuthRepository {
  OAuthRepositoryLocal({
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
      grantTypes: [
        'authorization_code',
        'refresh_token',
      ],
      scope: 'atproto',
      responseTypes: ['code'],
      applicationType: 'web',
      tokenEndpointAuthMethod: 'none',
    );
    oAuthClient ??= OAuthClient(clientMetadata!, service: service);
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
}
