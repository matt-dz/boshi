import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({
    super.key,
    required post,
    required atProtoRepository,
  })  : _atProtoRepository = atProtoRepository,
        _post = post;

  final AtProtoRepository _atProtoRepository;
  final Post _post;

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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is a typical dialog.'),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
