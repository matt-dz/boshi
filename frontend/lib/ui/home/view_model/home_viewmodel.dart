import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';
import 'package:frontend/ui/models/like/like.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Feed page
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    updateReactionCount = Command1<Post, ReactionPayload>(
      _updateReactionCount,
    );
    toggleLike = Command1<void, Like>(_toggleLike);
  }

  late final Command0 load;
  late final Command1 toggleLike;
  late final Command1 updateReactionCount;
  List<Post> _posts = [];
  User? _user;
  final AtProtoRepository _atProtoRepository;

  UnmodifiableListView<Post> get feed => UnmodifiableListView(_posts);

  Future<Result> _load() async {
    try {
      final userResult = await _atProtoRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
        case Error<User>():
          logger.e('Failed to retrieve user: ', error: userResult.error);
          return userResult;
      }

      final feedResult = await _atProtoRepository.getFeed();
      switch (feedResult) {
        case Ok<List<Post>>():
          _posts = feedResult.value;
        case Error<List<Post>>():
          return feedResult;
      }
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }

  void reload() {
    load = Command0(_load)..execute();
    notifyListeners();
  }

  Future<Result<void>> _toggleLike(Like like) async {
    try {
      if (_user == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _atProtoRepository.toggleLike(
        like.uri,
        like.cid,
        _user!.did,
        like.like,
      );
      if (result is Ok) {
        _posts = _posts.map((post) {
          if (post.uri.toString() == like.uri) {
            return post.copyWith(
              likedByUser: like.like,
              likes: post.likes + (like.like ? 1 : -1),
            );
          }
          return post;
        }).toList();
        logger.d('Post updated: $_posts');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<Post>> _updateReactionCount(
    ReactionPayload reactionPayload,
  ) async {
    throw UnimplementedError();
    // try {
    //   logger.d('Updating reaction count');
    //   final post = await _feedRepository.updateReactionCount(reactionPayload);

    //   if (post is Error<Post>) {
    //     logger.e('Error updating reaction count: ${post.error}');
    //   }
    //   return post;
    // } finally {
    //   notifyListeners();
    // }
  }
}
