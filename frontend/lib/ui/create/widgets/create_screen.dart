import 'package:flutter/material.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/header.dart';

import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/logger/logger.dart';

import '../view_model/create_viewmodel.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key, required this.viewModel});
  final CreateViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(child: CreateForm(viewModel: viewModel)),
          Footer(),
        ],
      ),
    );
  }
}

class CreateForm extends StatefulWidget {
  const CreateForm({super.key, required this.viewModel});

  final CreateViewModel viewModel;

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final formKey = GlobalKey<ShadFormState>();
  bool _titleExists = false;
  bool _contentExists = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (widget.viewModel.load.running) {
              return const Center(child: CircularProgressIndicator());
            } else if (widget.viewModel.load.error) {
              final result = widget.viewModel.load.result! as Error;
              return ErrorScreen(
                message: formatExceptionMsg(result.error),
                onRefresh: widget.viewModel.reload,
              );
            }

            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 24, bottom: 16),
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
                                final result =
                                    await widget.viewModel.createPost.execute(
                                  (
                                    formKey.currentState!.value['title'],
                                    formKey.currentState!.value['content']
                                  ),
                                );

                                switch (result) {
                                  case Ok<void>():
                                    logger.e('Successfully created post');
                                    if (context.mounted) {
                                      context.go('/');
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
                      Center(
                        child: Column(
                          children: [
                            Text('Posting as'),
                            Text(
                              widget.viewModel.user?.school ??
                                  'School not found',
                            ),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
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
              ),
            );
          },
        ),
      ),
    );
  }
}
