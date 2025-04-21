import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';
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
  final AtProtoRepository _atProtoRepository;

  List<Post> get feed => _posts;

  Future<Result> _load() async {
    try {
      final result = await _atProtoRepository.getFeed();
      if (result is Ok<List<Post>>) {
        _posts = result.value;
        logger.d(_posts);
      }
      return result;
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
      final result =
          await _atProtoRepository.toggleLike(like.uri, like.cid, like.like);
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
