import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/shared/models/post/post.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

/// ViewModel for the Feed page
class PostViewModel extends ChangeNotifier {
  PostViewModel({
    required AtProtoRepository atprotoRepository,
  }) : _atprotoRepository = atprotoRepository {
    createPost = Command1<void, Post>(_createPost);
  }

  late Command1<void, Post> createPost;
  final AtProtoRepository _atprotoRepository;

  Future<Result<void>> _createPost(Post post) async {
    try {
      logger.d('Creating a post');
      final createPostResult = await _atprotoRepository.createPost(post);
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
