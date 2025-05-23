import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/internal/feed/feed.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/internal/logger/logger.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final title = extractTitle(post);
    logger.d('title: $title');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: post.author.school,
                    style:
                        Theme.of(context).primaryTextTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.orangeAccent,
                            ),
                  ),
                  TextSpan(
                    text: '・ ${timeSincePosting(post)}',
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        title.isNotEmpty
            ? Text(
                title,
                style: Theme.of(context).primaryTextTheme.labelLarge,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.viewModel,
  });

  final PostViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: viewModel.disableLike ? null : viewModel.toggleLike.execute,
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.resolveWith(
              (state) => EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
          ),
      child: Row(
        spacing: 4,
        children: [
          Icon(
            viewModel.post.post.isLiked
                ? PhosphorIconsFill.heart
                : PhosphorIconsRegular.heart,
            color: viewModel.post.post.isLiked
                ? Colors.red
                : Theme.of(context).iconTheme.color,
            size: 20,
          ),
          Text(
            '${viewModel.post.post.likeCount}',
            style: Theme.of(context).primaryTextTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: viewModel.post.post.isLiked
                      ? Colors.red
                      : Theme.of(context).iconTheme.color,
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
    required this.viewModel,
  });

  final PostViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: viewModel.disableReply
          ? null
          : () {
              final encodedUri = base64Url
                  .encode(utf8.encode(viewModel.post.post.uri.toString()));
              context.go(
                '/post/$encodedUri',
              );
            },
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.resolveWith(
              (state) => EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
          ),
      child: Row(
        spacing: 4,
        children: [
          Icon(
            PhosphorIconsRegular.chatCircle,
            color: Theme.of(context).iconTheme.color,
            size: 20,
          ),
          Text(
            '${viewModel.post.post.replyCount}',
            style: Theme.of(context).primaryTextTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).iconTheme.color,
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
    required this.viewModel,
  });

  final PostViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(viewModel: viewModel),
        ReplyButton(viewModel: viewModel),
      ],
    );
  }
}

class PostFeed extends StatelessWidget {
  const PostFeed({
    super.key,
    required this.viewModel,
    this.replyIndent = 0,
    this.shadowColor = Colors.grey,
  });

  final PostViewModel viewModel;
  final int replyIndent;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    logger.d('PostFeed build');
    return Container(
      padding: EdgeInsets.all(8),
      constraints: BoxConstraints(minWidth: 350, maxHeight: 250),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: viewModel.isPost
                ? Theme.of(context).dividerColor
                : Colors.transparent,
          ),
        ),
      ),
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: PostHeader(post: viewModel.post),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    extractContext(viewModel.post),
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ),
                PostFooter(
                  viewModel: viewModel,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
