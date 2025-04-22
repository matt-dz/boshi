import 'package:flutter/material.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';
import 'package:frontend/ui/post_thread/view_model/post_thread_viewmodel.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({
    super.key,
    required this.viewModel,
  });

  final PostThreadViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.replies.isEmpty) {
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

    return ListView.builder(
      itemCount: viewModel.replies.length,
      itemBuilder: (context, index) {
        final reply = viewModel.replies[index];
        return PostFeed(
          key: Key(reply.post.cid),
          viewModel: PostViewModel(
            atProtoRepository: viewModel.atProtoRepository,
            post: reply,
          ),
        );
      },
    );
  }
}
