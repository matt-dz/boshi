import 'package:flutter/cupertino.dart';
import 'package:frontend/data/models/requests/reply/reply.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the Feed page
class ReplyViewModel extends ChangeNotifier {
  ReplyViewModel({
    required AtProtoRepository atProtoRepository,
  }) : _atProtoRepository = atProtoRepository {
    createReply = Command1<void, Reply>(_createReply);
  }

  late final Command0 load;
  late final Command1<void, Reply> createReply;
  final AtProtoRepository _atProtoRepository;

  String? get userDid => _atProtoRepository.atProto?.oAuthSession?.sub;

  Future<Result<void>> _createReply(Reply reply) async {
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
