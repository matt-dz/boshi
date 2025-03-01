import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/ui/login/view_model/login.dart';
import 'package:frontend/ui/login/view_model/login_redirect.dart';
import 'package:frontend/ui/home/view_model/home_viewmodel.dart';
import 'package:frontend/ui/home/widgets/home_screen.dart';

import 'package:frontend/data/repositories/feed/feed_repository.dart';
import 'package:frontend/data/repositories/user/user_repository.dart';

import 'package:frontend/data/repositories/oauth.dart';

import 'main_development.dart' as dev;

void main() {
  usePathUrlStrategy();
  dev.main();
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (context) => OAuthRepository(
  //           clientId: Uri.base.isScheme('http')
  //               ? Uri.base
  //               : Uri.parse('${Uri.base.origin}/oauth/client-metadata.json'),
  //         ),
  //       ),
  //     ],
  //     child: const MainApp(),
  //   ),
  // );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
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
          builder: (context, state) => LoginPage(),
          routes: [
            GoRoute(
              path: '/redirect',
              builder: (context, state) => Consumer<OAuthRepository>(
                builder: (context, oauth, child) {
                  if (oauth.atProtoSession == null) {
                    oauth.generateSession(Uri.base.toString());
                  }
                  return RedirectPage(atpSession: oauth.atProtoSession);
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
