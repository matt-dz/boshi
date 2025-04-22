import 'package:flutter/material.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:go_router/go_router.dart';

import '../view_model/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.viewModel,
  });

  final ProfileViewModel viewModel;

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

                  return Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Column(
                      spacing: 4,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'Welcome back',
                          style:
                              Theme.of(context).primaryTextTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          textAlign: TextAlign.center,
                          viewModel.user.handle!,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).focusColor,
                              ),
                        ),
                        Text(
                          viewModel.user.school,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.orange,
                              ),
                        ),
                        const Spacer(),
                        TextButton(
                          style: Theme.of(context).textButtonTheme.style,
                          onPressed: () async {
                            await viewModel.logout.execute();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          },
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
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
