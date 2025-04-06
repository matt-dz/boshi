import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/data/services/local/local_data_service.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/feed/feed_repository_remote.dart';
import 'package:frontend/data/repositories/feed/feed_repository_local.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';
import 'package:frontend/data/repositories/user/user_repository_remote.dart';
import 'package:frontend/data/repositories/user/user_repository_local.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository_remote.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository_local.dart';

import 'environment.dart';

List<SingleChildWidget> _sharedProviders = [
  // ChangeNotifierProvider(
  //   create: (context) => atprotoRepository(
  //     clientId: Uri.base.isScheme('http')
  //         ? Uri.base
  //         : Uri.parse('${Uri.base.origin}/atproto/client-metadata.json'),
  //   ),
  // ),
];

List<SingleChildWidget> get providersRemote {
  final apiClientPort = int.parse(EnvironmentConfig.backendPort);

  return [
    ..._sharedProviders,
    Provider<ApiClient>(
      create: (_) => ApiClient(
        host: EnvironmentConfig.backendBaseURL,
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
    ChangeNotifierProvider(
      create: (context) => AtProtoRepositoryRemote(
        clientId: Uri.parse(
          '${EnvironmentConfig.backendBaseURL}:${EnvironmentConfig.backendPort}/oauth/client-metadata.json',
        ),
        apiClient: context.read<ApiClient>(),
      ) as AtProtoRepository,
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
    ChangeNotifierProvider(
      create: (context) => AtProtoRepositoryLocal(
        clientId: Uri.parse('http://localhost:$frontendPort'),
        localDataService: context.read<LocalDataService>(),
      ) as AtProtoRepository,
    ),
  ];
}
