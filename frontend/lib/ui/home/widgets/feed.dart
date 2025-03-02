import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';

import 'post.dart';

class FeedWidget extends StatelessWidget {
  const FeedWidget({
    super.key,
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
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
            for (final post in posts)
              PostWidget(
                key: Key(post.id),
                post: post,
              ),
          ],
        ),
      ],
    );
  }
}
