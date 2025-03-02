import 'package:flutter/material.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';

import '../view_model/home_viewmodel.dart';
import 'feed.dart';

import 'package:frontend/utils/logger.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title, required this.viewModel});

  final HomeViewModel viewModel;
  final String title;

  @override
  Widget build(BuildContext context) {
    logger.d('Feed: ${viewModel.posts}');
    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Column(
              children: [
                Header(title: title),
                Expanded(
                  child: FeedWidget(
                    posts: viewModel.posts,
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
