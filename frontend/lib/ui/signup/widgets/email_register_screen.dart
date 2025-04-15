import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../view_model/email_register_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/utils/logger.dart';

const emailId = 'email';
final emailRegex = RegExp(r'.+\@.+'); // lax af

class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({super.key, required this.viewModel});

  final EmailRegisterViewModel viewModel;

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, state) {
            return Center(
              child: SignupForm(
                viewModel: widget.viewModel,
              ),
            );
          },
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.viewModel,
  });

  final EmailRegisterViewModel viewModel;

  @override
  State<SignupForm> createState() => _SignupForm();
}

class _SignupForm extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String? _errMsg;
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final result = widget.viewModel.addEmail.result;
    switch (result) {
      case Ok<void>():
        context.go(
          '/signup/verify?email='
          '${Uri.encodeComponent(emailController.text)}',
        );
      default:
        break;
    }
    widget.viewModel.addEmail.clearResult();

    return ShadCard(
      width: 400,
      title: const Text('Enter University Email'),
      description: const Text('We use your university email '
          'to verify your student status. We will never sell your data.'),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  errorText: _errMsg,
                ),
                enabled: !widget.viewModel.addEmail.running,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Email must not be empty';
                  }

                  if (emailRegex.matchAsPrefix(v) == null) {
                    return 'Invalid email';
                  }

                  if (!v.endsWith('.edu')) {
                    return 'Email must end in .edu';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Reset error message
                  setState(() {
                    _errMsg = null;
                  });

                  if (!_formKey.currentState!.validate()) {
                    logger.d('here');
                    return;
                  }
                  final result = await widget.viewModel.addEmail
                      .execute(emailController.text);
                  if (result is Error<void>) {
                    setState(() {
                      _errMsg = result.error.toString();
                    });
                  }
                },
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
