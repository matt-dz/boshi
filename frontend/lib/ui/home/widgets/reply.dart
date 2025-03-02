import 'package:flutter/material.dart';
import 'package:frontend/domain/models/reply/reply.dart';
import 'package:frontend/utils/content_item.dart';

class ReplyWidget extends StatelessWidget {
  const ReplyWidget({
    super.key,
    required this.reply,
    required this.replyDepth,
  });

  final Reply reply;
  final int replyDepth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB((8 + replyDepth * 50).toDouble(), 16, 8, 16),
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
                  '${reply.author.username} ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${reply.author.school}'
                  ' ・ ${timeSincePosting(reply)}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              reply.content,
            ),
          ],
        ),
      ),
    );
  }
}
