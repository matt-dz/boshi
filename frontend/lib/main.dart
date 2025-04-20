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
import 'package:frontend/ui/signup/widgets/email_register_screen.dart';
import 'package:frontend/ui/signup/view_model/email_register_viewmodel.dart';
import 'package:frontend/ui/signup/widgets/email_verification_screen.dart';
import 'package:frontend/ui/signup/view_model/email_verification_viewmodel.dart';

import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:frontend/utils/auth.dart';
import 'package:frontend/config/environment.dart';
import 'package:logger/logger.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'config/dependencies.dart';

void main() {
  Logger.level = Level.all;
  usePathUrlStrategy();
  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      redirect: (context, state) async {
        if (!EnvironmentConfig.prod) {
          return await localRouteGuard(context, state);
        }
        return await prodRouteGuard(context, state);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          redirect: rootRouteGuard,
          builder: (context, state) => HomeScreen(
            title: 'Boshi',
            viewModel: HomeViewModel(
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
        GoRoute(
          path: '/signup',
          redirect: signupRouteGuard,
          builder: (context, state) => EmailRegisterScreen(
            viewModel: EmailRegisterViewModel(
              atProtoRepository: context.read<AtProtoRepository>(),
            ),
          ),
          routes: [
            GoRoute(
              redirect: verifyEmailRouteGuard,
              path: '/verify',
              builder: (context, state) => EmailVerificationScreen(
                viewModel: EmailVerificationViewModel(
                  atProtoRepository: context.read<AtProtoRepository>(),
                ),
                email: state.uri.queryParameters['email']!,
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
