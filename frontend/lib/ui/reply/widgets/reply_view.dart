import 'package:atproto/atproto.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/ui/home/widgets/post.dart';
import 'package:frontend/ui/reply/view_model/reply_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showReplyDialog(BuildContext context, Post parent) {
  showDialog(
    context: context,
    builder: (_) => ReplyWidget(
      viewModel: ReplyViewModel(
        atProtoRepository: context.read<AtProtoRepository>(),
        parent: parent,
      ),
    ),
  );
}

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({
    super.key,
    required this.viewModel,
  });

  final ReplyViewModel viewModel;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  final formKey = GlobalKey<ShadFormState>();
  bool _contentExists = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        width: 450,
        constraints: BoxConstraints(minWidth: 350),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShadButton.ghost(
                  height: 30,
                  width: 120,
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
                ShadButton.ghost(
                  height: 30,
                  width: 120,
                  enabled: _contentExists,
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      final result = await widget.viewModel.createReply.execute(
                        bsky.PostRecord(
                          text: formKey.currentState!.value['content'],
                          reply: bsky.ReplyRef(
                            parent: StrongRef(
                              uri: widget.viewModel.parent.post.uri,
                              cid: widget.viewModel.parent.post.cid,
                            ),
                            root: StrongRef(
                              uri: widget.viewModel.parent.post.uri,
                              cid: widget.viewModel.parent.post.cid,
                            ),
                          ),
                          createdAt: DateTime.now(),
                        ),
                      );

                      switch (result) {
                        case Ok<void>():
                          logger.e('Successfully created post');
                          if (context.mounted) {
                            context.pop();
                          }
                          return;
                        case Error():
                          logger.e('Error creating post in: $result');
                          return;
                      }
                    }
                  },
                  child: const Text('Reply'),
                ),
              ],
            ),
            SizedBox(height: 12),
            PostFeed(
              key: Key(widget.viewModel.parent.post.cid),
              post: widget.viewModel.parent,
              onLike: () {
                if (widget.viewModel.parent.post.isLiked) {
                  widget.viewModel.removeLike.execute();
                  return;
                }
                widget.viewModel.addLike.execute();
              },
            ),
            ShadForm(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ShadInputFormField(
                      id: 'content',
                      placeholder: Text(
                        'Do you think the same?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                      ),
                      decoration: ShadDecoration(
                        border: ShadBorder.none,
                        disableSecondaryBorder: true,
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Don't you want to speak your truth?";
                        }
                        return null;
                      },
                      onChanged: (String content) => setState(() {
                        _contentExists = content.isNotEmpty;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
