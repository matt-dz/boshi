import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/src/model/oauth/oauth_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(child: Text('Login')),
      floatingActionButton: Consumer<OAuthRepository>(
        builder: (context, oauth, child) {
          return FilledButton(
            onPressed: () async {
              Uri authUri = await oauth.getAuthorizationURI("");
              if (!await launchUrl(authUri)) {
                throw Exception('Could not launch $authUri');
              }
            },
            child: const Text("Login"),
          );
        },
      ),
    );
  }
}
