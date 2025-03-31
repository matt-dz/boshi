import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/ui/login/widgets/login_screen.dart';
import 'package:frontend/ui/login/widgets/redirect_screen.dart';
import 'package:frontend/ui/login/view_model/login_viewmodel.dart';

import 'package:frontend/ui/home/view_model/home_viewmodel.dart';
import 'package:frontend/ui/home/widgets/home_screen.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';
import 'package:frontend/data/repositories/oauth/oauth_repository.dart';

import 'main_development.dart' as dev;

void main() {
  dev.main();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      redirect: (context, state) {
        const env = String.fromEnvironment('ENV');
        if (env != 'PROD') {
          return null;
        }
        final oauth = context.read<OAuthRepository>();
        final isLoggedIn = oauth.atProto != null;
        final isLoggingIn = state.uri.path.startsWith('/login');

        // Redirect to login if trying to access protected pages
        // without being logged in
        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }

        // Prevent logged-in users from visiting the login page again
        if (isLoggedIn && isLoggingIn) {
          return '/';
        }

        // No redirection needed
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(
            title: 'Boshi',
            viewModel: HomeViewModel(
              feedRepository: context.read<FeedRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(
            viewModel: LoginViewModel(
              oAuthRepository: context.read<OAuthRepository>(),
            ),
          ),
          routes: [
            GoRoute(
              path: '/redirect',
              builder: (context, state) => Consumer<OAuthRepository>(
                builder: (context, oauth, child) {
                  if (oauth.atProto == null) {
                    oauth.generateSession(Uri.base.toString());
                  }
                  return RedirectScreen(atpSession: oauth.atProto);
                },
              ),
            ),
          ],
        ),
      ],
    );

    return ShadApp.materialRouter(
      materialThemeBuilder: (context, theme) {
        return theme.copyWith();
      },
      routerConfig: router,
    );
  }
}
