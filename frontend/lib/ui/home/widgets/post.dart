import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.post,
  });

  final Post post;

  String _timeSincePosting(Post post) {
    final currentTime = DateTime.now().toUtc();
    final timeDifference = currentTime.difference(post.timestamp.toUtc());

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: post.author.school,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '・ ${_timeSincePosting(post)}',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          post.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.liked,
    required this.likes,
    required this.onLike,
  });

  final bool liked;
  final int likes;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onLike,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        side: BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        spacing: 4,
        children: [
          Icon(
            liked ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
            color: liked ? Colors.red : Colors.black,
            size: 20,
          ),
          Text(
            '$likes',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyButton extends StatelessWidget {
  const ReplyButton({
    super.key,
    required this.numReplies,
    required this.onReply,
  });

  final int numReplies;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onReply,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        side: BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        spacing: 4,
        children: [
          Icon(
            LucideIcons.messageCircle,
            size: 20,
          ),
          Text(
            '$numReplies',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class PostFooter extends StatelessWidget {
  const PostFooter({
    super.key,
    required this.post,
    required this.onLike,
    required this.onReply,
  });

  final VoidCallback onLike;
  final VoidCallback onReply;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        LikeButton(likes: post.likes, liked: post.likedByUser, onLike: onLike),
        ReplyButton(numReplies: post.numReplies, onReply: onReply),
      ],
    );
  }
}

class PostFeed extends StatelessWidget {
  const PostFeed({
    super.key,
    required this.post,
    required this.onLike,
    required this.onReply,
    this.replyIndent = 0,
    this.shadowColor = Colors.grey,
  });

  final Post post;
  final int replyIndent;
  final Color shadowColor;
  final VoidCallback onLike;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8 + replyIndent * 50, 16, 8, 16),
      child: Container(
        padding: EdgeInsets.all(8),
        width: 450,
        constraints: BoxConstraints(minWidth: 350, maxHeight: 250),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            PostHeader(post: post),
            Text(post.content),
            PostFooter(
              post: post,
              onLike: onLike,
              onReply: onReply,
            ),
          ],
        ),
      ),
    );
  }
}
