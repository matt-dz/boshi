import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

/// ViewModel for the Feed page
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
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

  Future<Result> _load() async {
    try {
      logger.d('Retrieving feed');
      final feedResult = await _feedRepository.getFeed();
      switch (feedResult) {
        case Ok<List<Post>>():
          _posts = feedResult.value;
          logger.d('Retrieved feed');
        case Error<List<Post>>():
          logger.e('Error loading feed: ${feedResult.error}');
          return feedResult;
      }

      logger.d('Retrieving user');
      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
        case Error<User>():
          logger.e('Error retrieving user: ${userResult.error}');
      }
      return userResult;
    } finally {
      notifyListeners();
    }
  }
}
