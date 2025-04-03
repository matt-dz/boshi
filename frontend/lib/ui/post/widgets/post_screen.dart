import 'package:flutter/material.dart';
import 'package:frontend/shared/models/post/post.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/header.dart';

import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/logger.dart';

import '../view_model/post_viewmodel.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key, required this.title, required this.viewModel});

  final String title;
  final PostViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: title),
          Expanded(child: PostForm(viewModel: viewModel)),
          Footer(),
        ],
      ),
    );
  }
}

class PostForm extends StatefulWidget {
  const PostForm({super.key, required this.viewModel});

  final PostViewModel viewModel;

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final formKey = GlobalKey<ShadFormState>();
  bool _titleExists = false;
  bool _contentExists = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: ShadCard(
        width: 400,
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
                    context.go('/');
                  },
                  child: const Text('Cancel'),
                ),
                ShadButton.ghost(
                  height: 30,
                  width: 120,
                  enabled: _titleExists && _contentExists,
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      final result = await widget.viewModel.createPost.execute(
                        Post(
                          title: formKey.currentState!.value['title'],
                          content: formKey.currentState!.value['content'],
                        ),
                      );

                      switch (result) {
                        case Ok<void>():
                          logger.e('Successfully created post');
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
            const Center(
              child: Column(
                children: [
                  Text('Posting as'),
                  Text('University of Florida | eifmsa'),
                ],
              ),
            ),
            ShadForm(
              key: formKey,
              child: Column(
                children: [
                  ShadInputFormField(
                    id: 'title',
                    placeholder: Text(
                      'Title',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                        return "What's the title to your truth?";
                      }
                      return null;
                    },
                    onChanged: (String title) => setState(() {
                      _titleExists = title.isNotEmpty;
                    }),
                  ),
                  ShadInputFormField(
                    id: 'content',
                    placeholder: Text(
                      'Speak your truth...',
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
