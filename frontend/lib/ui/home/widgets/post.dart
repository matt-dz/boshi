import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';

String timeSince(DateTime time) {
  final currentTime = DateTime.now().toUtc();
  final timeDifference = currentTime.difference(time.toUtc());

  if (timeDifference.inDays >= 7) {
    return '${timeDifference.inDays ~/ 7}w';
  } else if (timeDifference.inDays >= 1) {
    return '${timeDifference.inDays}d';
  } else if (timeDifference.inHours >= 1) {
    return '${timeDifference.inHours}h';
  } else if (timeDifference.inMinutes >= 1) {
    return '${timeDifference.inMinutes}m';
  } else {
    return '${timeDifference.inSeconds}s';
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Container(
        padding: EdgeInsets.all(8),
        width: 450,
        constraints: BoxConstraints(
          minWidth: 350,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              children: [
                Text(
                  '${post.author.username} ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${post.author.school} ・ ${timeSince(post.timestamp)}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            Text(
              post.content,
            ),
          ],
        ),
      ),
    );
  }
}
