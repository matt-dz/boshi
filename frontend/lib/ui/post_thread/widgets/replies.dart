import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';
import 'package:frontend/ui/post_thread/view_model/post_thread_viewmodel.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({
    super.key,
    required this.replies,
    required this.viewModel,
  });

  final UnmodifiableListView<Post> replies;
  final PostThreadViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (replies.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'No posts yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return ListView(
      children: [
        Column(
          children: [
            for (final reply in replies)
              PostFeed(
                // key: Key(post.post.cid),
                viewModel: PostViewModel(
                  atProtoRepository: viewModel.atProtoRepository,
                  post: reply,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
