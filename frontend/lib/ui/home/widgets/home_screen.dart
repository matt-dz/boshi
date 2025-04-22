import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/domain/models/post/post.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post.dart';
import 'package:provider/provider.dart';

import '../view_model/home_viewmodel.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key, required this.feed, required this.viewModel});

  final HomeViewModel viewModel;
  final UnmodifiableListView<Post> feed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            for (final post in feed)
              PostFeed(
                key: Key(post.post.cid),
                viewModel: PostViewModel(
                  atProtoRepository: context.read<AtProtoRepository>(),
                  post: post,
                ),
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
            Header(),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  if (viewModel.load.running) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } else if (viewModel.load.error) {
                    final result = viewModel.load.result! as Error;
                    return ErrorScreen(
                      message: formatExceptionMsg(result.error),
                      onRefresh: viewModel.reload,
                    );
                  }

                  return FeedView(
                    feed: viewModel.feed,
                    viewModel: viewModel,
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
