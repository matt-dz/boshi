import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<ShadFormState>();
  bool _titleExists = false;
  bool _contentExists = false;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _post() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final result = await widget.viewModel.createPost.execute(
        (
          _formKey.currentState!.value['title'],
          _formKey.currentState!.value['content']
        ),
      );

      switch (result) {
        case Ok<void>():
          logger.e('Successfully created post');
          if (mounted) {
            context.go('/');
          }
          return;
        case Error():
          logger.e('Error creating post in: $result');
          return;
      }
    }
  }

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
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: const Color(0xFF7DD3FC)),
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            onPressed: () {
                              context.pop();
                            },
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .labelMedium,
                            ),
                          ),
                          OutlinedButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            onPressed:
                                _titleExists && _contentExists ? _post : null,
                            child: Text(
                              'Post',
                              style: _titleExists && _contentExists
                                  ? Theme.of(context)
                                      .primaryTextTheme
                                      .labelMedium
                                  : Theme.of(context)
                                      .primaryTextTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context).disabledColor,
                                      ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Posting as',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineMedium,
                            ),
                            Text(
                              widget.viewModel.user?.school ??
                                  'School not found',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextField(
                              cursorColor: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyLarge
                                  ?.color,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyLarge,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                                hintText: 'Title',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _titleExists = value.isNotEmpty;
                                });
                              },
                              controller: _titleController,
                            ),
                            TextField(
                              cursorColor: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium
                                  ?.color,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintStyle: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                                hintText: 'Speak your truth...',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _contentExists = value.isNotEmpty;
                                });
                              },
                              controller: _contentController,
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
