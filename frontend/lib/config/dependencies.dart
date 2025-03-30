import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/data/services/local/local_data_service.dart';
import 'package:frontend/config/environment.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/feed/feed_repository_remote.dart';
import 'package:frontend/data/repositories/feed/feed_repository_local.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';
import 'package:frontend/data/repositories/user/user_repository_remote.dart';
import 'package:frontend/data/repositories/user/user_repository_local.dart';
import 'package:frontend/data/repositories/oauth/oauth_repository.dart';
import 'package:frontend/data/repositories/oauth/oauth_repository_remote.dart';
import 'package:frontend/data/repositories/oauth/oauth_repository_local.dart';

List<SingleChildWidget> _sharedProviders = [
  // ChangeNotifierProvider(
  //   create: (context) => OAuthRepository(
  //     clientId: Uri.base.isScheme('http')
  //         ? Uri.base
  //         : Uri.parse('${Uri.base.origin}/oauth/client-metadata.json'),
  //   ),
  // ),
];

List<SingleChildWidget> get providersRemote {
  // TODO: Add logging
  final apiClientPort = int.parse(EnvironmentConfig.backendPort);

  return [
    ..._sharedProviders,
    Provider<ApiClient>(
      create: (_) => ApiClient(
        host: EnvironmentConfig.backendHost,
        port: apiClientPort,
      ),
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        apiClient: context.read<ApiClient>(),
      ) as UserRepository,
    ),
    Provider(
      create: (context) => FeedRepositoryRemote(
        apiClient: context.read<ApiClient>(),
      ) as FeedRepository,
    ),
    Provider(
      create: (context) => OAuthRepositoryRemote(
        clientId: Uri.base,
        apiClient: context.read<ApiClient>(),
      ) as OAuthRepository,
    ),
  ];
}

List<SingleChildWidget> get providersLocal {
  const frontendPort = String.fromEnvironment(
    'FRONTEND_PORT',
    defaultValue: '3000',
  );

  return [
    ..._sharedProviders,
    Provider<LocalDataService>(
      create: (_) => LocalDataService(),
    ),
    Provider(
      create: (context) => UserRepositoryLocal(
        localDataService: context.read<LocalDataService>(),
      ) as UserRepository,
    ),
    Provider(
      create: (context) => FeedRepositoryLocal(
        localDataService: context.read<LocalDataService>(),
      ) as FeedRepository,
    ),
    Provider(
      create: (context) => OAuthRepositoryLocal(
        clientId: Uri.parse('http://localhost:$frontendPort'),
        localDataService: context.read<LocalDataService>(),
      ) as OAuthRepository,
    ),
  ];
}
