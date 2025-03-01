import 'dart:io';

import 'package:frontend/config/environment.dart';

class ApiClient {
  ApiClient(String? host, int? port, HttpClient Function()? clientFactory)
      : _host = host ?? EnvironmentConfig.backendHost,
        _port = port ?? int.parse(EnvironmentConfig.backendPort),
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;
}
