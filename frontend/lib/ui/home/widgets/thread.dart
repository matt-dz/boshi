import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/reply/reply.dart';
import 'package:frontend/utils/logger.dart';

import 'content_item.dart';

void _dfs(Reply reply, int depth, List<ContentItemWidget> replies) {
  replies.add(
    ContentItemWidget(
      key: Key(reply.id),
      post: reply,
      replyIndent: depth,
    ),
  );

  for (final comment in reply.comments) {
    _dfs(comment, depth + 1, replies);
  }
}

List<ContentItemWidget> retrieveReplies(Post post) {
  final List<ContentItemWidget> replies = [];
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
        ContentItemWidget(
          post: post,
        ),
        ...retrieveReplies(post),
      ],
    );
  }
}
