import 'package:atproto/core.dart';
import 'package:flutter/material.dart';

import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/internal/logger/logger.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/ui/reply/widgets/reply_view.dart';

/// ViewModel for the Feed page
class PostViewModel extends ChangeNotifier {
  PostViewModel({
    required AtProtoRepository atProtoRepository,
    required Post post,
    bool? disableLike,
    bool? disableReply,
  })  : _atProtoRepository = atProtoRepository,
        _post = post {
    toggleLike = Command0(_toggleLike);
    handleReply = Command1<void, BuildContext>(_handleReply);
  }

  late final Command0 toggleLike;
  late final Command1 handleReply;

  final AtProtoRepository _atProtoRepository;
  final Post _post;

  AtProtoRepository get atProtoRepository => _atProtoRepository;
  String? get userDid => _atProtoRepository.atProto?.oAuthSession?.sub;
  Post get post => _post;

  Future<Result<void>> _handleReply(BuildContext context) async {
    try {
      final replyResult = await showReplyDialog(context, this);
      logger.d(replyResult);
      switch (replyResult) {
        case Ok<void>():
          _post.post = _post.post.copyWith(
            replyCount: _post.post.replyCount + 1,
          );
        case Error<void>():
          logger.d('did not create reply');
      }
      return replyResult;
    } finally {
      notifyListeners();
    }
  }

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
