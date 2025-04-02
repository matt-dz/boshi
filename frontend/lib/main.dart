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

import 'package:frontend/utils/result.dart';

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
        final oauth = context.read<OAuthRepository>();
        final isLoggingIn = state.uri.path.startsWith('/login');
        if (!oauth.authorized && !isLoggingIn) {
          print('naughty naughty');
          final result = await oauth.generateSession(Uri.base.toString());
          if (result is Error<void>) {
            print(result.error);
            print('naughty naughty - sending you back');
            return '/login';
          }
        } else if (oauth.authorized && isLoggingIn) {
          return '/';
        }
        print('all good');
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
              builder: (context, state) => RedirectScreen(),
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
