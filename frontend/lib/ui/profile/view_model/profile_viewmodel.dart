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

  late Command0 load;
  late final Command0 logout;

  late final User _user;
  final AtProtoRepository _atProtoRepository;

  User get user => _user;

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

  Future<Result<void>> _logout() async {
    try {
      return await _atProtoRepository.logout();
    } finally {
      notifyListeners();
    }
  }
}
