import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/cupertino.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/post/post.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Feed page
class ReplyViewModel extends ChangeNotifier {
  ReplyViewModel({
    required AtProtoRepository atProtoRepository,
    required Post parent,
    VoidCallback? onLike,
  })  : _atProtoRepository = atProtoRepository,
        _parent = parent,
        _onLike = onLike {
    createReply = Command1<void, bsky.PostRecord>(_createReply);
  }

  late final Command0 load;
  late final Command1<void, bsky.PostRecord> createReply;

  final AtProtoRepository _atProtoRepository;
  final Post _parent;
  final VoidCallback? _onLike;

  String? get userDid => _atProtoRepository.atProto?.oAuthSession?.sub;
  Post get parent => _parent;
  VoidCallback? get onLike => _onLike;

  Future<Result<void>> _createReply(bsky.PostRecord reply) async {
    try {
      logger.d('Creating a reply');
      final createReplyResult = await _atProtoRepository.createReply(reply);
      switch (createReplyResult) {
        case Ok<void>():
          logger.d('Successfully created post');
        case Error<void>():
          logger.e('Error creating post: ${createReplyResult.error}');
      }
      return createReplyResult;
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
        _parent.post.uri,
        _parent.post.cid,
        userDid!,
      );

      if (result is Error) {
        return result;
      }

      _parent.post = _parent.post.copyWith(
        viewer: _parent.post.viewer.copyWith(
          like: null,
        ),
        likeCount: _parent.post.likeCount - 1,
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
        _parent.post.uri,
        _parent.post.cid,
      );

      switch (result) {
        case Error():
          return result;
        case Ok():
          final likeUri = result.value;
          _parent.post = _parent.post.copyWith(
            viewer: _parent.post.viewer.copyWith(
              like: likeUri,
            ),
            likeCount: _parent.post.likeCount + 1,
          );
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
