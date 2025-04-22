import 'package:flutter/material.dart';
import 'package:frontend/ui/post_thread/view_model/post_thread_viewmodel.dart';
import 'package:frontend/ui/post_thread/widgets/post_thread_screen.dart';
import 'ui/create/view_model/create_viewmodel.dart';
import 'ui/create/widgets/create_screen.dart';
import 'package:frontend/ui/profile/view_model/profile_viewmodel.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'ui/login/widgets/login_screen.dart';
import 'ui/login/widgets/oauth_callback_screen.dart';
import 'ui/login/view_model/login_viewmodel.dart';
import 'ui/profile/widgets/profile_screen.dart';

import 'ui/home/view_model/home_viewmodel.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/signup/widgets/email_register_screen.dart';
import 'ui/signup/view_model/email_register_viewmodel.dart';
import 'ui/signup/widgets/email_verification_screen.dart';
import 'ui/signup/view_model/email_verification_viewmodel.dart';

import 'package:frontend/data/repositories/atproto/atproto_repository.dart';

import 'package:logger/logger.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'internal/guards/guards.dart';
import 'internal/config/environment.dart';
import 'internal/config/dependencies.dart';

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
          path: '/profile',
          builder: (context, state) => ProfileScreen(
            viewModel: ProfileViewModel(
              atProtoRepository: context.read<AtProtoRepository>(),
            ),
          ),
        ),
        GoRoute(
          path: '/post/:rooturl',
          builder: (context, state) => PostThreadScreen(
            viewModel: PostThreadViewModel(
              atProtoRepository: context.read<AtProtoRepository>(),
              rootUrl: state.pathParameters['rooturl']!,
            ),
          ),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) => CreateScreen(
            viewModel: CreateViewModel(
              atProtoRepository: context.read<AtProtoRepository>(),
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
        return theme.copyWith(
          scaffoldBackgroundColor: Color(0xFF2E2C3A),
          iconTheme: IconThemeData(color: Color(0xFF6C7086)),
          primaryIconTheme: IconThemeData(color: Color(0xFFF4F4F9)),
          dividerColor: Color(0xFFC9C9D9),
          primaryTextTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF4F4F9),
            ),
            displayMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFFF4F4F9),
            ),
            displaySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFFF4F4F9),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFF4F4F9),
            ),
            labelLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF4F4F9),
            ),
            labelMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFF4F4F9),
            ),
            labelSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF4F4F9),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
              minimumSize: Size.zero,
              side: BorderSide(color: Colors.transparent),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
      routerConfig: router,
    );
  }
}
