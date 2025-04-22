import 'package:atproto/atproto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/ui/post_thread/view_model/post_thread_viewmodel.dart';
import 'package:bluesky/bluesky.dart' as bsky;
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReplyInputWidget extends StatefulWidget {
  const ReplyInputWidget({
    super.key,
    required this.viewModel,
  });

  final PostThreadViewModel viewModel;

  @override
  State<ReplyInputWidget> createState() => _ReplyInputWidgetState();
}

class _ReplyInputWidgetState extends State<ReplyInputWidget> {
  final formKey = GlobalKey<ShadFormState>();
  bool _contentExists = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 350),
      child: Row(
        children: [
          Expanded(
            child: ShadForm(
              key: formKey,
              child: ShadInputFormField(
                id: 'content',
                placeholder: Text(
                  'Thoughts?',
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
                        cid: widget.viewModel.post.post.cid,
                        uri: widget.viewModel.post.post.uri,
                      ),
                      root: widget.viewModel.post.root ??
                          StrongRef(
                            uri: widget.viewModel.post.post.uri,
                            cid: widget.viewModel.post.post.cid,
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
    );
  }
}
