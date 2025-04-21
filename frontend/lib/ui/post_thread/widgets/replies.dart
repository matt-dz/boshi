import 'package:bluesky/bluesky.dart';
import 'package:flutter/material.dart';

class RepliesWidget extends StatelessWidget {
  const RepliesWidget({
    super.key,
    this.replies,
  });

  final List<PostThreadView>? replies;

  @override
  Widget build(BuildContext context) {
    if (replies == null || replies!.isEmpty) {
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
