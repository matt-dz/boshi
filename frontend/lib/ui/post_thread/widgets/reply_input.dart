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
  final TextEditingController _replyController = TextEditingController();

  bool _replyEmpty = true;

  void _onReply() async {
    final result = await widget.viewModel.createReply.execute(
      bsky.PostRecord(
        text: _replyController.text,
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
        logger.d('Successfully created reply');
        _formKey.currentState?.reset();
        _replyController.clear();
      case Error():
        logger.e('Error creating reply with: $result');
    }
  }

  @override
  void initState() {
    super.initState();
    _replyController.addListener(() {
      setState(() {
        _replyEmpty = _replyController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 350),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextField(
                controller: _replyController,
                minLines: 1,
                maxLines: 4,
                cursorColor:
                    Theme.of(context).primaryTextTheme.bodySmall?.color,
                style: Theme.of(context).primaryTextTheme.bodySmall,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF223C48),
                  contentPadding: EdgeInsets.all(12),
                  hintStyle:
                      Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
                            color: Color(0xFFC3CAEB),
                          ),
                  hintText: 'Thoughts?',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: OutlinedButton(
              style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.resolveWith((states) {
                  return const Size(56, 28);
                }),
                shape: WidgetStateProperty.resolveWith((states) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  );
                }),
                side: WidgetStateProperty.resolveWith((states) {
                  return BorderSide(
                    width: 2,
                    color: states.contains(WidgetState.disabled)
                        ? Color(0xFF636363)
                        : Color(0xffa0cafa),
                  );
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.disabled)
                      ? Color(0xFF434343)
                      : Color(0xff63a0eb);
                }),
              ),
              onPressed: _replyEmpty ? null : _onReply,
              child: Text(
                'Reply',
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
