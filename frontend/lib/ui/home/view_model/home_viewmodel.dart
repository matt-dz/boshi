/* Retrieve feed from the feed repository */
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({
    required FeedRepository feedRepository,
    required UserRepository userRepository,
  })  : _feedRepository = feedRepository,
        _userRepository = userRepository {
    load = Command0(_load)..execute();
  }

  late Command0 load;
  final FeedRepository _feedRepository;
  final UserRepository _userRepository;

  User? _user;
  User? get user => _user;

  List<Post> _posts = [];
  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  // TODO: Add logging
  Future<Result> _load() async {
    try {
      final feedResult = await _feedRepository.getFeed();
      switch (feedResult) {
        case Ok<List<Post>>():
          _posts = feedResult.value;
        case Error<List<Post>>():
          return feedResult;
      }

      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
          return userResult;
        case Error<User>():
          return userResult;
      }
    } finally {
      notifyListeners();
    }
  }
}
