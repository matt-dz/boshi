import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Profile screen
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    logout = Command0(_logout);
  }

	/// The command to load the user profile.
  late Command0 load;

	/// The command to log out the user.
  late final Command0 logout;

	/// The user object representing the logged-in user.
  late final User _user;
  User get user => _user;

	/// The repository for interacting with the AT Protocol.
  final AtProtoRepository _atProtoRepository;


	/// Loads the user profile data from the repository.
  Future<Result> _load() async {
    try {
      final userResult = await _atProtoRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
          return Result.ok(null);
        case Error<User>():
          logger.e('Failed to retrieve user: ', error: userResult.error);
          return userResult;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> reload() async {
    load = Command0(_load)..execute();
    notifyListeners();
  }

	/// Logs out the user from Boshi.
  Future<Result<void>> _logout() async {
    try {
      return await _atProtoRepository.logout();
    } finally {
      notifyListeners();
    }
  }
}
