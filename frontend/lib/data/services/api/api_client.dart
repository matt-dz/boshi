import 'dart:io';

import 'package:frontend/utils/result.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

class ApiClient {
  ApiClient({String? host, int? port, HttpClient Function()? clientFactory})
      : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  // TODO: Implement the getFeed method
  Future<Result<List<Post>>> getFeed() async {
    return Result.error(throw UnimplementedError());
  }

  // TODO: Implement the getUser method
  Future<Result<User>> getUser() async {
    return Result.error(throw UnimplementedError());
  }
}
