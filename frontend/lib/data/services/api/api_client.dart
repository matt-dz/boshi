import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

class ApiClient {
  ApiClient(String? host, int? port, HttpClient Function()? clientFactory)
      : _host = host ?? EnvironmentConfig.backendHost,
        _port = port ?? int.parse(EnvironmentConfig.backendPort),
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  // TODO: Implement the getFeed method
  Future<Result<List<Post>>> getFeed() async {
    return Result.error(throw UnimplementedError());
  }
}
