import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/data/services/local/local_data_service.dart';
import 'user_repository.dart';

class UserRepositoryLocal extends UserRepository {
  UserRepositoryLocal({required LocalDataService localDataService})
      : _localDataService = localDataService;

  final LocalDataService _localDataService;

  @override
  Future<Result<User>> getUser() async {
    return _localDataService.getUser();
  }
}
