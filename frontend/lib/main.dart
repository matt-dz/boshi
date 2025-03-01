import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/ui/login/view_model/login.dart';
import 'package:frontend/data/repositories/oauth.dart';
import 'package:frontend/ui/login/view_model/login_redirect.dart';

import 'package:frontend/ui/home/widgets/home_screen.dart';

Future<void> main() async {
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OAuthRepository(
            clientId: Uri.base.isScheme('http')
                ? Uri.base
                : Uri.parse('${Uri.base.origin}/oauth/client-metadata.json'),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(title: 'Boshi'),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.verified_user)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<OAuthRepository>(
              builder: (context, oauth, child) {
                if (oauth.atProtoSession != null) {
                  return Text(
                      'Your session: ${oauth.atProtoSession?.identity}');
                } else {
                  oauth.refreshSession();
                  return Text('Please sign in.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
