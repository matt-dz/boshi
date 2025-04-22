import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';
import 'package:provider/provider.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({
    super.key,
    required this.replies,
  });

  final List<Post> replies;

  @override
  Widget build(BuildContext context) {
    logger.d(replies);

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
            for (final post in replies)
              PostFeed(
                key: Key(post.post.cid),
                viewModel: PostViewModel(
                  atProtoRepository: context.read<AtProtoRepository>(),
                  post: post,
                  disableReply: true,
                ),
              ),
          ],
        ),
      ],
    );
    ;
  }
}
