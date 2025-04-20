import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/exceptions/not_authorized_exception.dart';

import 'package:frontend/shared/models/post/post.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

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
      logger.d('Retrieving user ');
      if (_atProtoRepository.authorized) {
        final String? user = _atProtoRepository.atProto?.oAuthSession?.sub;

        if (user == null) {
          return Result.error(Exception('No authenticated user'));
        }

        final userResult = await _atProtoRepository.getUser(user);
        switch (userResult) {
          case Ok<User>():
            _user = userResult.value;
          case Error<User>():
            logger.e('Error retrieving user: ${userResult.error}');
        }
        return userResult;
      }
      return Result.error(NotAuthorizedException('GetUser'));
    } finally {
      notifyListeners();
    }
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
