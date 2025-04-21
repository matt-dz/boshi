import 'package:flutter/material.dart';
import 'package:frontend/data/models/requests/reply/reply.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/ui/reply/view_model/reply_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({
    super.key,
    required this.post,
    required this.viewModel,
  });

  final Post post;
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        Reply(
                          rootCid: '',
                          rootUri: '',
                          postCid: '',
                          postUri: '',
                          authorId: widget.viewModel.userDid ?? 'invalid',
                          content: formKey.currentState!.value['content'],
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
                  child: const Text('Post'),
                ),
              ],
            ),
            SizedBox(height: 30),
            ShadForm(
              key: formKey,
              child: Column(
                children: [
                  ShadInputFormField(
                    id: 'content',
                    placeholder: Text(
                      'Is that really your truth?',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
