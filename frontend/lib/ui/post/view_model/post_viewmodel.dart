import 'package:atproto/core.dart';
import 'package:flutter/material.dart';

import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';

/// ViewModel for the Feed page
class PostViewModel extends ChangeNotifier {
  PostViewModel({
    required AtProtoRepository atProtoRepository,
    required Post post,
    bool disableLike = false,
    bool disableReply = false,
  })  : _atProtoRepository = atProtoRepository,
        _post = post,
        _disableReply = disableReply,
        _disableLike = disableLike {
    toggleLike = Command0(_toggleLike);
  }

  late final Command0 toggleLike;

  final AtProtoRepository _atProtoRepository;
  final Post _post;
  final bool _disableReply;
  final bool _disableLike;

  AtProtoRepository get atProtoRepository => _atProtoRepository;
  String? get userDid => _atProtoRepository.atProto?.oAuthSession?.sub;
  Post get post => _post;
  bool get disableReply => _disableReply;
  bool get disableLike => _disableLike;

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
