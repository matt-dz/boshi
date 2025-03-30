import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view_model/login_viewmodel.dart';
import 'package:frontend/ui/models/login/login.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ShadCard(
          width: 350,
          title: const Text('Sign In'),
          description: const Text('Use your identity to sign in with OAuth'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ShadForm(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShadInputFormField(
                    textAlign: TextAlign.center,
                    id: 'auth_provider',
                    label: const Center(
                      child: Text(
                        'Account Provider',
                        style: TextStyle(height: 0.2),
                      ),
                    ),
                    initialValue: 'bsky.social',
                    description: const Center(
                      child: Text(
                        'Choose your account provider.',
                        style: TextStyle(height: 0.2),
                      ),
                    ),
                    validator: (v) {
                      if (v.isEmpty) {
                        return 'Provider must not be empty.'
                            "Default value is 'bsky.social'";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ShadInputFormField(
                    id: 'identity',
                    label: const Text('Identity'),
                    placeholder: const Text('Enter your identity'),
                    description: const Text(
                      'Login with any identifier on the atprotocol',
                    ),
                    validator: (v) {
                      if (v.isEmpty) {
                        return 'Identifier must not be empty.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ShadButton(
                    child: const Text('Log in'),
                    onPressed: () async {
                      if (formKey.currentState!.saveAndValidate()) {
                        final result = await widget.viewModel.login.execute(
                          Login(
                            oAuthService:
                                formKey.currentState!.value['auth_provider'],
                            identity: formKey.currentState!.value['identity'],
                          ),
                        );

                        switch (result) {
                          case Ok<Uri>():
                            try {
                              if (!await launchUrl(result.value)) {
                                logger.e('Unable to launch url');
                              }
                            } on PlatformException catch (e) {
                              logger.e('Error launching URL: $e');
                            }
                          case Error():
                            logger.e('Error signing in: $result');
                            return;
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
