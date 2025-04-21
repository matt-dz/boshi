import 'package:flutter/material.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'post.dart';

import '../view_model/home_viewmodel.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key, required this.feed});

  final List<Post> feed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            for (final post in feed)
              PostFeed(
                key: Key(post.cid),
                post: post,
              ),
          ],
        ),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title, required this.viewModel});

  final HomeViewModel viewModel;
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

                  return FeedView(
                    feed: (viewModel.load.result! as Ok).value as List<Post>,
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
