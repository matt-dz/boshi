import 'package:frontend/utils/result.dart';
import 'package:frontend/data/services/api/api_client.dart';
import 'oauth_repository.dart';
import 'package:atproto/atproto_oauth.dart';
import 'package:atproto/atproto.dart' as atp;

class OAuthRepositoryRemote extends OAuthRepository {
  OAuthRepositoryRemote({
    required super.clientId,
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  Future<void> _initializeOAuthClient() async {
    print('Retrieving metadata from ${clientId.toString()}');
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
      print('retrieved');
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
}
