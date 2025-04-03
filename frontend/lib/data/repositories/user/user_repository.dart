import 'package:frontend/utils/result.dart';
import 'package:frontend/domain/models/user/user.dart';

/// Retrieves and formats data from the feed service
abstract class UserRepository {
  Future<Result<User>> getUser();
}
