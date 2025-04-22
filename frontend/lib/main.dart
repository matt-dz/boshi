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
          scaffoldBackgroundColor: const Color(0xFF2E2C3A),
          focusColor: const Color(0xFF7DD3FC),
          iconTheme: IconThemeData(color: const Color(0xFF6C7086)),
          primaryIconTheme: IconThemeData(color: const Color(0xFFF4F4F9)),
          dividerColor: const Color(0xFFC9C9D9),
          disabledColor: const Color(0xFF6C7086),
          textTheme: TextTheme(
            labelSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF6C7086),
            ),
          ),
          primaryTextTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF4F4F9),
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF4F4F9),
            ),
            headlineSmall: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFF4F4F9),
            ),
            displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF4F4F9),
            ),
            displayMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFF4F4F9),
            ),
            displaySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF4F4F9),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFF4F4F9),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFF4F4F9),
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFF4F4F9),
            ),
            labelLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF4F4F9),
            ),
            labelMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF4F4F9),
            ),
            labelSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFF4F4F9),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              padding: WidgetStateProperty.resolveWith(
                (states) => EdgeInsets.all(16),
              ),
              minimumSize:
                  WidgetStateProperty.resolveWith((states) => Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: WidgetStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              backgroundColor:
                  WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.transparent;
                }
                if (states.contains(WidgetState.hovered)) {
                  return Color(0xFF4d4d4d);
                }
                return Colors.transparent;
              }),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  );
                }
                return TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                );
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.black26;
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.black;
                }
                return Colors.white;
              }),
              padding: WidgetStateProperty.resolveWith((state) {
                return EdgeInsets.all(16);
              }),
              minimumSize: WidgetStateProperty.resolveWith((states) {
                return Size.zero;
              }),
              side: WidgetStateProperty.resolveWith((states) {
                return BorderSide(color: Colors.transparent);
              }),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: WidgetStateProperty.resolveWith((status) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                );
              }),
            ),
          ),
        );
      },
      routerConfig: router,
    );
  }
}
