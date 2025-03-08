import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/domain/models/content_item/content_item.dart';
import 'package:frontend/domain/models/reaction/reaction.dart';
import 'package:frontend/utils/content_item.dart';

import 'package:frontend/utils/logger.dart';

// TODO: Figure out padding issue
class ReactionWrapper extends StatelessWidget {
  const ReactionWrapper({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(8, 12, 8, 12),
  });

  final Widget child;
  final void Function()? onPressed;
  final EdgeInsetsGeometry padding;

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
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: padding,
          fixedSize: Size(double.infinity, 24),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class ReactionEmote extends StatelessWidget {
  const ReactionEmote({
    super.key,
    required this.reaction,
  });

  final Reaction reaction;

  @override
  Widget build(BuildContext context) {
    return ReactionWrapper(
      onPressed: () {
        logger.d('${reaction.emote} pressed!');
      },
      child: Text(
        '${reaction.emote} ${reaction.count}',
      ),
    );
  }
}

class ContentItemHeader extends StatelessWidget {
  const ContentItemHeader({
    super.key,
    required this.post,
  });

  final ContentItem post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Spacer(),
            IconButton(
              icon: Icon(
                PhosphorIconsRegular.dotsThreeVertical,
                size: 20,
              ),
              onPressed: () {
                logger.d('dots pressed!');
              },
            ),
          ],
        ),
        if (post is Post)
          Text(
            (post as Post).title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
      ],
    );
  }
}

class AddReactionButton extends StatelessWidget {
  const AddReactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactionWrapper(
      onPressed: () {
        logger.d('plus pressed!');
      },
      child: Icon(
        PhosphorIconsRegular.plus,
        size: 20,
        color: Colors.black,
      ),
    );
  }
}

class ContentItemFooter extends StatelessWidget {
  const ContentItemFooter({
    super.key,
    required this.post,
  });

  final ContentItem post;

  @override
  Widget build(BuildContext build) {
    final reactions = post.reactions.map(
      (reaction) => ReactionEmote(reaction: reaction),
    );

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ...reactions,
          AddReactionButton(),
        ],
      ),
    );
  }
}

class ContentItemWidget extends StatelessWidget {
  const ContentItemWidget({
    super.key,
    required this.post,
    this.replyIndent = 0,
    this.shadowColor = Colors.grey,
  });

  final ContentItem post;
  final int replyIndent;
  final Color shadowColor;

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
            color: Colors.grey.shade400,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            ContentItemHeader(post: post),
            Text(
              post.content,
            ),
            ContentItemFooter(post: post),
          ],
        ),
      ),
    );
  }
}
