import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({
    super.key,
    required this.replies,
  });

  final List<Post> replies;

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
    return Text('Not yet implemented');
  }
}
