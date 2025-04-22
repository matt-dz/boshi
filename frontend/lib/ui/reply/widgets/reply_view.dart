import 'package:atproto/atproto.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:flutter/material.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';
import 'package:frontend/ui/reply/view_model/reply_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<Result<void>> showReplyDialog(
  BuildContext context,
  PostViewModel parentViewModel,
) async {
  return await showDialog(
    context: context,
    builder: (_) => ReplyWidget(
      viewModel: ReplyViewModel(
        parentViewModel: parentViewModel,
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
                    context.pop(
                      Result.error(Exception('Cancelled creating reply')),
                    );
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
                            context.pop(result);
                          }
                        case Error():
                          logger.e('Error creating post with: $result');
                      }
                    }
                  },
                  child: const Text('Reply'),
                ),
              ],
            ),
            SizedBox(height: 12),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return PostFeed(
                  key: Key(widget.viewModel.parent.post.cid),
                  viewModel: widget.viewModel.parentViewModel,
                );
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
