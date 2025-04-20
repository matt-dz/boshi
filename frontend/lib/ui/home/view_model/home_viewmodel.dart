import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/exceptions/not_authorized_exception.dart';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/command.dart';
import 'package:frontend/utils/logger.dart';

/// ViewModel for the Feed page
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required FeedRepository feedRepository,
    required UserRepository userRepository,
    required AtProtoRepository atProtoRepository,
  })  : _feedRepository = feedRepository,
        _userRepository = userRepository,
        _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    updateReactionCount = Command1<Post, ReactionPayload>(
      _updateReactionCount,
    );
  }

  late Command0 load;
  late Command1 updateReactionCount;
  final FeedRepository _feedRepository;
  final UserRepository _userRepository;
  final AtProtoRepository _atProtoRepository;

  User? _user;
  User? get user => _user;

  List<Post> _posts = [];
  UnmodifiableListView<Post> get posts => UnmodifiableListView(_posts);

  Future<Result> _load() async {
    try {
      logger.d('Retrieving feed');
      final feedResult = await _atProtoRepository.getFeed();
      switch (feedResult) {
        case Ok<List<Post>>():
          _posts = feedResult.value;
          logger.d('Retrieved feed');
        case Error<List<Post>>():
          logger.e('Error loading feed: ${feedResult.error}');
      }
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

  Future<Result<Post>> _updateReactionCount(
    ReactionPayload reactionPayload,
  ) async {
    try {
      logger.d('Updating reaction count');
      final post = await _feedRepository.updateReactionCount(reactionPayload);

      if (post is Error<Post>) {
        logger.e('Error updating reaction count: ${post.error}');
      }
      return post;
    } finally {
      notifyListeners();
    }
  }
}
