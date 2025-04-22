import 'package:flutter/material.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';
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
        body: Column(
          children: [
            Header(title: title),
            Expanded(
              child: ListenableBuilder(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PostFeed(
                        viewModel: PostViewModel(
                          atProtoRepository: viewModel.atProtoRepository,
                          post: viewModel.post,
                        ),
                      ),
                      RepliesWidget(
                        replies: viewModel.replies,
                        viewModel: viewModel,
                      ),
                    ],
                  );
                },
              ),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
