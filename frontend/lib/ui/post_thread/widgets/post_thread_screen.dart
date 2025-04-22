import 'package:flutter/material.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:frontend/ui/post_thread/widgets/replies.dart';

import '../view_model/post_thread_viewmodel.dart';

class PostThreadScreen extends StatelessWidget {
  const PostThreadScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final PostThreadViewModel viewModel;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.load.running) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.load.error) {
              final result = viewModel.load.result! as Error;
              return ErrorScreen(
                message: formatExceptionMsg(result.error),
                onRefresh: viewModel.reload,
              );
            }

            return Column(
              children: [
                Header(title: title),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ContentItemWidget(post: ),
                      RepliesWidget(replies: viewModel.thread?.replies),
                    ],
                  ),
                ),
                Footer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
