import 'package:flutter/material.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';

import '../view_model/home_viewmodel.dart';
import 'feed.dart';

import 'package:frontend/utils/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title, required this.viewModel});

  final HomeViewModel viewModel;
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    logger.d('Feed: ${widget.viewModel.posts}');
    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return Column(
              children: [
                Header(title: widget.title),
                Expanded(
                  child: FeedWidget(
                    posts: widget.viewModel.posts,
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
