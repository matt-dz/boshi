import 'package:atproto/atproto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/ui/post_thread/view_model/post_thread_viewmodel.dart';
import 'package:bluesky/bluesky.dart' as bsky;
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
  final _formKey = GlobalKey<ShadFormState>();
  final TextEditingController _controller = TextEditingController();
  bool _validState() {
    return _controller.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_validState);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 350),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ShadInputFormField(
                controller: _controller,
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
              ),
            ),
          ),
          ShadButton.ghost(
            height: 30,
            width: 120,
            enabled: _validState(),
            onPressed: () async {
              if (_validState()) {
                final result = await widget.viewModel.createReply.execute(
                  bsky.PostRecord(
                    text: _controller.text,
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
                    logger.e('Successfully created reply');
                    _controller.clear();
                  case Error():
                    logger.e('Error creating reply with: $result');
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
