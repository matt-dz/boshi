import 'dart:collection';

import 'package:atproto/atproto.dart';
import 'package:atproto/core.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/foundation.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/internal/feed/post_thread.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/command/command.dart';
import 'package:frontend/internal/logger/logger.dart';

/// ViewModel for the PostThread screen
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
  late final Command1 createReply;
  final AtProtoRepository _atProtoRepository;
  final String _rootUrl;

  late Post _post;
  late List<Post> _replies;

  AtProtoRepository get atProtoRepository => _atProtoRepository;
  Post get post => _post;
  UnmodifiableListView<Post> get replies => UnmodifiableListView(_replies);

  Future<Result> _load() async {
    try {
      logger.d('Retrieving post thread');
      final postThreadResult =
          await _atProtoRepository.getPostThread(AtUri.parse(_rootUrl));
      switch (postThreadResult) {
        case Ok<bsky.PostThread>():
          final threadView =
              postThreadResult.value.thread.whenOrNull(record: (data) => data);

          if (threadView == null) {
            return Result.error(Exception("Couldn't verify thread"));
          }

          final Set<String> dids = {};
          extractDidsFromPostThread(threadView, dids);

          final users = await _atProtoRepository.getUsers(dids.toList());

          switch (users) {
            case Ok<List<User>>():
              final repliesToSort = extractRepliesFromPostThread(
                StrongRef(cid: threadView.post.cid, uri: threadView.post.uri),
                getRootFromPostThread(threadView),
                threadView.replies,
                users.value,
              );
              repliesToSort.sort(
                (Post a, Post b) => b.post.indexedAt.compareTo(
                  a.post.indexedAt,
                ),
              );
              _replies = repliesToSort;

              _post = Post(
                bskyPost: threadView.post,
                author: users.value.firstWhere(
                  (user) => user.did == threadView.post.author.did,
                ),
                replies: _replies,
                root: getRootFromPostThread(threadView),
              );

            case Error<List<User>>():
              logger.e('Failed to fetch users from post thread');
              return Result.error(Exception('Failed to fetch users'));
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
    load.execute();
    notifyListeners();
  }

  Future<Result<void>> _createReply(bsky.PostRecord reply) async {
    try {
      logger.d('Creating a reply');
      final createReplyResult = await _atProtoRepository.createReply(reply);
      switch (createReplyResult) {
        case Ok<void>():
          logger.d('Successfully created reply');
        case Error<void>():
          logger.e('Error creating reply: ${createReplyResult.error}');
      }
      return createReplyResult;
    } finally {
      reload();
    }
  }
}
