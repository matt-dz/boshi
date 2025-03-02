import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/reply/reply.dart';
import 'package:frontend/utils/logger.dart';

import 'post.dart';
import 'reply.dart';

void _dfs(Reply reply, int depth, List<ReplyWidget> replies) {
  replies.add(
    ReplyWidget(
      key: Key(reply.id),
      reply: reply,
      replyDepth: depth,
    ),
  );

  for (final comment in reply.comments) {
    _dfs(comment, depth + 1, replies);
  }
}

List<ReplyWidget> retrieveReplies(Post post) {
  final List<ReplyWidget> replies = [];
  for (final reply in post.comments) {
    _dfs(reply, 1, replies);
  }
  return replies;
}

class Thread extends StatelessWidget {
  const Thread({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    logger.d('Thread: ${post.id}, $post');
    return Column(
      children: [
        PostWidget(
          post: post,
        ),
        ...retrieveReplies(post),
      ],
    );
  }
}
