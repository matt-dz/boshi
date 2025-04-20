import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/shared/models/reaction_payload/reaction_payload.dart';

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
  }

  late final Command0 load;
  late final Command1 updateReactionCount;
  final AtProtoRepository _atProtoRepository;

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
      return feedResult;
    } finally {
      notifyListeners();
    }
  }

  void reload() {
    load = Command0(_load)..execute();
    notifyListeners();
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
