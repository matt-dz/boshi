import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/cupertino.dart';
import 'package:frontend/domain/models/post/post.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';

/// ViewModel for the Feed page
class ReplyViewModel extends ChangeNotifier {
  ReplyViewModel({
    required PostViewModel parentViewModel,
  }) : _parentViewModel = parentViewModel {
    createReply = Command1<void, bsky.PostRecord>(_createReply);
  }

  late final Command0 load;
  late final Command1<void, bsky.PostRecord> createReply;

  final PostViewModel _parentViewModel;

  PostViewModel get parentViewModel => _parentViewModel;
  Post get parent => _parentViewModel.post;

  Future<Result<void>> _createReply(bsky.PostRecord reply) async {
    try {
      logger.d('Creating a reply');
      final createReplyResult =
          await _parentViewModel.atProtoRepository.createReply(reply);
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
