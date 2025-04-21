import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/ui/reply/view_model/reply_viewmodel.dart';
import 'package:frontend/ui/reply/widgets/reply_view.dart';
import 'package:provider/provider.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({super.key});

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ReplyWidget(
        post: Post(
          content: 'hello',
          title: 'hi',
          school: 'school',
          indexedAt: DateTime.now(),
        ),
        viewModel: ReplyViewModel(
          atProtoRepository: context.read<AtProtoRepository>(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showDialog(context),
      child: const Text('Show Dialog'),
    );
  }
}
