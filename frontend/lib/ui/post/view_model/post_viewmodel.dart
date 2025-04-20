import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/shared/models/post/post.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Feed page
class PostViewModel extends ChangeNotifier {
  PostViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    createPost = Command1<void, Post>(_createPost);
  }

  late Command0 load;
  late Command1<void, Post> createPost;
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
    createPost = Command1(_createPost);
    notifyListeners();
  }

  Future<Result<void>> _createPost(Post post) async {
    try {
      logger.d('Creating a post');
      final createPostResult = await _atProtoRepository.createPost(post);
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
