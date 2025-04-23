import 'package:atproto/core.dart';
import 'package:flutter/material.dart';

import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/internal/feed/feed.dart';

import 'package:frontend/domain/models/post/post.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';

/// ViewModel for the post screen
class PostViewModel extends ChangeNotifier {
  PostViewModel({
    required AtProtoRepository atProtoRepository,
    required Post post,
    bool disableLike = false,
    bool disableReply = false,
  })  : _atProtoRepository = atProtoRepository,
        _post = post,
        _disableReply = disableReply,
        _disableLike = disableLike,
        _title = extractTitle(post) {
    toggleLike = Command0(_toggleLike);
  }

	/// The command to toggle the like status of a post.
  late final Command0 toggleLike;

	/// The command to add a like to a post.
  final AtProtoRepository _atProtoRepository;
  AtProtoRepository get atProtoRepository => _atProtoRepository;

	/// The post object from the Bluesky API.
  final Post _post;
  Post get post => _post;

	/// Whether the reply button should be disabled.
  final bool _disableReply;
  bool get disableReply => _disableReply;

	/// Whether the like button should be disabled.
  final bool _disableLike;
  bool get disableLike => _disableLike;

	/// The title of the post.
  final String _title;

	/// Determine if the post is a reply.
  bool get isReply => _title.isEmpty;

	/// Determine if the post is a post.
  bool get isPost => _title.isNotEmpty;

	/// Retrieve the user's DID from the AT Protocol session.
  String? get userDid => _atProtoRepository.atProto?.oAuthSession?.sub;


	/// Toggle the like status of the post.
	///
	/// @returns A [Result] indicating the success or failure of the operation.
  Future<Result<void>> _toggleLike() async {
    try {
      if (_post.post.isLiked) {
        return _removeLike();
      }
      return _addLike();
    } finally {
      notifyListeners();
    }
  }

	/// Remove a like from the post.
	///
	/// @returns A [Result] indicating the success or failure of the operation.
  Future<Result<void>> _removeLike() async {
    try {
      if (userDid == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _atProtoRepository.removeLike(
        _post.post.uri,
        _post.post.cid,
        userDid!,
      );

      if (result is Error) {
        return result;
      }

      _post.post = _post.post.copyWith(
        viewer: _post.post.viewer.copyWith(
          like: null,
        ),
        likeCount: _post.post.likeCount - 1,
      );

      return result;
    } finally {
      notifyListeners();
    }
  }

	/// Add a like to the post.
	///
	/// @returns A [Result] indicating the success or failure of the operation.
  Future<Result<AtUri>> _addLike() async {
    try {
      if (userDid == null) {
        return Result.error(Exception('User not logged in'));
      }

      final result = await _atProtoRepository.addLike(
        _post.post.uri,
        _post.post.cid,
      );

      switch (result) {
        case Error():
          return result;
        case Ok():
          final likeUri = result.value;
          _post.post = _post.post.copyWith(
            viewer: _post.post.viewer.copyWith(
              like: likeUri,
            ),
            likeCount: _post.post.likeCount + 1,
          );
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
