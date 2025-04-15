import 'package:flutter/material.dart';
import 'package:frontend/ui/post/view_model/post_viewmodel.dart';
import 'package:frontend/ui/post/widgets/post_screen.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/ui/login/widgets/login_screen.dart';
import 'package:frontend/ui/login/widgets/oauth_callback_screen.dart';
import 'package:frontend/ui/login/view_model/login_viewmodel.dart';

import 'package:frontend/ui/home/view_model/home_viewmodel.dart';
import 'package:frontend/ui/home/widgets/home_screen.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/logger.dart';
import 'package:frontend/config/environment.dart';

import 'main_development.dart' as dev;

void main() {
  dev.main();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      redirect: (BuildContext context, GoRouterState state) async {
        final oauth = context.read<AtProtoRepository>();
        final isLoggingIn = state.uri.path.startsWith('/login');
        final onOAuthCallback = state.uri.path.startsWith('/oauth/callback');

        if (EnvironmentConfig.prod) {
          if (!oauth.authorized && !(isLoggingIn || onOAuthCallback)) {
            final result = await oauth.refreshSession();
            if (result is Error<void>) {
              return '/login';
            }
          } else if (oauth.authorized && isLoggingIn) {
            return '/';
          }
        } else {
          if (oauth.authorized) {
            logger.d('user is authorized');
            return null;
          }

          logger.d('user not authorized, refreshing session...');
          var result = await oauth.refreshSession();
          if (result is Ok<void>) {
            logger.d('user is authorized');
            return null;
          }
          logger.e(result);
          logger.e('Failed to refresh session. Attempting to generate...');

          result = await oauth.generateSession(Uri.base.toString());
          if (result is Ok<void>) {
            logger.d('session generated');
            return null;
          }
          logger.e('Failed to generate session: ${result.toString()}');
          return '/login';
        }
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
              atProtoRepository: context.read<AtProtoRepository>(),
            ),
          ),
        ),
        GoRoute(
          path: '/post',
          builder: (context, state) => PostScreen(
            title: 'Boshi',
            viewModel: PostViewModel(
              atprotoRepository: context.read<AtProtoRepository>(),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(
            viewModel: LoginViewModel(
              atProtoRepository: context.read<AtProtoRepository>(),
            ),
          ),
        ),
        GoRoute(
          path: '/oauth/callback',
          builder: (context, state) => OAuthCallback(),
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
