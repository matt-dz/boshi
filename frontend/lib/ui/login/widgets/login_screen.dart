import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view_model/login_viewmodel.dart';
import 'package:frontend/ui/models/login/login.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/internal/logger/logger.dart';

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
      body: Center(
        child: ShadCard(
          width: 350,
          title: Text(
            'Boshi Log In',
            style: Theme.of(context).primaryTextTheme.headlineLarge,
          ),
          description: Text(
            'Use your identity to sign in with OAuth',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: const Color(0xFF7DD3FC)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ShadForm(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShadInputFormField(
                    decoration: ShadDecoration(
                      color: Colors.black26,
                    ),
                    cursorColor:
                        Theme.of(context).primaryTextTheme.bodySmall?.color,
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                    textAlign: TextAlign.center,
                    id: 'auth_provider',
                    label: Center(
                      child: Text(
                        'Account Provider',
                        style: Theme.of(context).primaryTextTheme.labelMedium,
                      ),
                    ),
                    initialValue: 'bsky.social',
                    description: Center(
                      child: Text(
                        'Choose your account provider.',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .labelSmall
                            ?.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
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
                    style: Theme.of(context).primaryTextTheme.bodySmall,
                    decoration: ShadDecoration(
                      color: Colors.black26,
                    ),
                    cursorColor:
                        Theme.of(context).primaryTextTheme.bodySmall?.color,
                    label: Text(
                      'Identity',
                      style: Theme.of(context).primaryTextTheme.labelMedium,
                    ),
                    placeholder: Text(
                      'Enter your identity',
                      style: Theme.of(context).primaryTextTheme.bodySmall,
                    ),
                    description: Text(
                      'Login with any identifier on the atprotocol',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelSmall
                          ?.copyWith(
                            color: Theme.of(context).disabledColor,
                          ),
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
                    backgroundColor: Color(0xFF38BDF8),
                    hoverBackgroundColor: Color(0xDF38BDF8),
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
                              if (!await launchUrl(
                                result.value,
                                webOnlyWindowName: '_self',
                              )) {
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
