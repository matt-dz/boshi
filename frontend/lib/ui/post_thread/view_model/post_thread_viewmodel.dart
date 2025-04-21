import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Feed page
class PostThreadViewModel extends ChangeNotifier {
  PostThreadViewModel({
    required AtProtoRepository atProtoRepository,
    required String rootUrl,
  })  : _atProtoRepository = atProtoRepository,
        _rootUrl = rootUrl {
    load = Command0(_load)..execute();
    createReply = Command1<void, bsky.PostRecord>(_createReply);
  }

  late final Command0 load;
  late final Command1<void, bsky.PostRecord> createReply;
  final AtProtoRepository _atProtoRepository;
  final String _rootUrl;

  bsky.PostThreadViewRecord? _thread;
  bsky.PostThreadViewRecord? get thread => _thread;

  Future<Result> _load() async {
    try {
      logger.d('Retrieving post thread');
      final postThreadResult = await _atProtoRepository.getPostThread(_rootUrl);
      switch (postThreadResult) {
        case Ok<bsky.PostThread>():
          _thread =
              postThreadResult.value.thread.whenOrNull(record: (data) => data);
          if (_thread == null) {
            return Result.error(Exception("Couldn't verify thread"));
          }
        case Error<bsky.PostThread>():
          logger.e('Error loading feed: ${postThreadResult.error}');
      }
      return postThreadResult;
    } finally {
      notifyListeners();
    }
  }

  void reload() {
    load = Command0(_load)..execute();
    notifyListeners();
  }

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
}
