import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Feed page
class CreateViewModel extends ChangeNotifier {
  CreateViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    createPost = Command1<void, (String, String)>(_createPost);
  }

  late final Command0 load;
  late final Command1<void, (String, String)> createPost;
  final AtProtoRepository _atProtoRepository;

  User? _user;
  User? get user => _user;

  Future<Result> _load() async {
    try {
      logger.d('Retrieving user');
      final userResult = await _atProtoRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
        case Error<User>():
          logger.e('Failed to retrieve user: ', error: userResult.error);
      }
      return userResult;
    } finally {
      notifyListeners();
    }
  }

  void reload() {
    load = Command0(_load)..execute();
    notifyListeners();
  }

  Future<Result<void>> _createPost((String, String) postValues) async {
    try {
      logger.d('Creating a post');
      final createPostResult =
          await _atProtoRepository.createPost(postValues.$1, postValues.$2);
      switch (createPostResult) {
        case Ok<void>():
          logger.d('Successfully created post');
          return createPostResult;
        case Error<void>():
          logger.e('Error creating post: ${createPostResult.error}');
          return createPostResult;
      }
    } finally {
      notifyListeners();
    }
  }
}
