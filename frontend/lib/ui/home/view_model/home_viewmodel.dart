import 'dart:collection';
import 'package:atproto/core.dart';

import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Home screen
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    load = Command0(_load)..execute();
    addLike = Command1<AtUri, Post>(_addLike);
    removeLike = Command1<void, Post>(_removeLike);
  }

  late final Command0 load;
  late final Command1 addLike;
  late final Command1 removeLike;

	/// The list of posts in the feed.
  List<Post> _posts = [];

	/// The user who is currently logged in.
  User? _user;
  UnmodifiableListView<Post> get feed => UnmodifiableListView(_posts);

	/// The repository for interacting with the AT Protocol.
  final AtProtoRepository _atProtoRepository;


	/// Loads the user and feed data from the repository.
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

	/// Removes a like from a post.
	///
	/// @param post The post to remove the like from.
	/// @returns A result indicating the success or failure of the operation.
  Future<Result<void>> _removeLike(Post post) async {
    try {
      if (_user == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _atProtoRepository.removeLike(
        post.post.uri,
        post.post.cid,
        _user!.did,
      );

      if (result is Error) {
        return result;
      }

      _posts = _posts.map((p) {
        if (p.post.uri == post.post.uri) {
          p.post = p.post.copyWith(
            viewer: p.post.viewer.copyWith(
              like: null,
            ),
            likeCount: post.post.likeCount - 1,
          );
        }
        return p;
      }).toList();
      return result;
    } finally {
      notifyListeners();
    }
  }

	/// Adds a like to a post.
	///
	/// @param post The post to add the like to.
	/// @returns A [Result] indicating the success or failure of the operation.
  Future<Result<AtUri>> _addLike(Post post) async {
    try {
      if (_user == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _atProtoRepository.addLike(
        post.post.uri,
        post.post.cid,
      );

      switch (result) {
        case Error():
          return result;
        case Ok():
          final likeUri = result.value;
          _posts = _posts.map((p) {
            if (p.post.uri == post.post.uri) {
              p.post = p.post.copyWith(
                viewer: p.post.viewer.copyWith(
                  like: likeUri,
                ),
                likeCount: post.post.likeCount + 1,
              );
            }
            return p;
          }).toList();
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
