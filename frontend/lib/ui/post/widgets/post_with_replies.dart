import 'package:flutter/material.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';

class PostWithRepliesWidget extends StatelessWidget {
  const PostWithRepliesWidget({
    super.key,
    required this.viewModel,
    this.replyIndent = 0,
    this.shadowColor = Colors.grey,
  });

  final PostViewModel viewModel;
  final int replyIndent;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    final replies = viewModel.post.replies?.map(
      (reply) => PostFeed(
        viewModel: PostViewModel(
          atProtoRepository: viewModel.atProtoRepository,
          post: reply,
        ),
        replyIndent: replyIndent + 1,
      ),
    );

    if (replies == null) {
      return PostFeed(
        viewModel: viewModel,
        replyIndent: replyIndent,
        shadowColor: shadowColor,
      );
    }

    return Column(
      children: [
        PostFeed(
          viewModel: viewModel,
          replyIndent: replyIndent,
          shadowColor: shadowColor,
        ),
        ...replies,
      ],
    );
  }
}
