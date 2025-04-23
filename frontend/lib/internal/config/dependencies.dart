import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:frontend/data/services/api/api_client.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'environment.dart';

/// Provides the necessary dependencies for the application.
List<SingleChildWidget> get providers {
  final clientId = EnvironmentConfig.prod
      ? '${EnvironmentConfig.backendBaseURL}/client-metadata.json'
      : 'http://localhost:${EnvironmentConfig.frontendPort}';

  return [
    Provider<ApiClient>(
      create: (_) => ApiClient(),
    ),
    ChangeNotifierProvider(
      create: (context) => AtProtoRepository(
        clientId: Uri.parse(clientId),
        apiClient: context.read<ApiClient>(),
        local: !EnvironmentConfig.prod,
      ),
    ),
  ];
}
