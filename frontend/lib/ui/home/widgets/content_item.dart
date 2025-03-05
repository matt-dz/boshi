import 'package:flutter/material.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/content_item/content_item.dart';
import 'package:frontend/domain/models/reaction/reaction.dart';
import 'package:frontend/utils/content_item.dart';

import 'package:frontend/utils/logger.dart';

class ReactionEmote extends StatelessWidget {
  const ReactionEmote({
    super.key,
    required this.reaction,
  });

  final Reaction reaction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
          minimumSize: Size(0, 0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        onPressed: () {
          logger.d('${reaction.emote} pressed!');
        },
        child: Text(
          '${reaction.emote} ${reaction.count}',
        ),
      ),
    );
  }
}

class ContentItemWidget extends StatelessWidget {
  const ContentItemWidget({
    super.key,
    required this.post,
    this.replyIndent = 0,
  });

  final ContentItem post;
  final int replyIndent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8 + replyIndent * 50, 16, 8, 16),
      child: Container(
        padding: EdgeInsets.all(8),
        width: 450,
        constraints: BoxConstraints(
          minWidth: 350,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${post.author.username} ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: post.author.school,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '・ ${timeSincePosting(post)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            if (post is Post)
              Text(
                (post as Post).title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            Text(
              post.content,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                spacing: 6,
                children: [
                  for (final reaction in post.reactions)
                    ReactionEmote(reaction: reaction),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
