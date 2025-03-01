import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/data/services/api/api_client.dart';

import 'user_repository.dart';

class UserRepositoryRemote extends UserRepository {
  UserRepositoryRemote({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  // TODO: Implement the getUser method
  @override
  Future<Result<User>> getUser() async {
    return await _apiClient.getUser();
}
