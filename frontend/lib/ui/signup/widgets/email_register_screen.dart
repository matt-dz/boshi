import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../view_model/email_register_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:frontend/ui/core/ui/error_controller.dart';
import 'package:frontend/exceptions/format.dart';

const emailId = 'email';
final emailRegex = RegExp(r'.+\@.+'); // lax af

String? emailInputValidator(String? v) {
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
}

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

  void _onSignup() async {
    // Reset error message
    setState(() {
      _errMsg = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Add email
    final result =
        await widget.viewModel.addEmail.execute(emailController.text);
    if (!mounted) {
      return;
    }

    if (result is Error<void>) {
      setState(() {
        _errMsg = formatExceptionMsg(result.error);
      });
      return;
    }

    // Navigate to verification screen
    context.go(
      '/signup/verify?email='
      '${Uri.encodeComponent(emailController.text)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final formEnabled = !(widget.viewModel.addEmail.running ||
        widget.viewModel.addEmail.completed);
    return ShadCard(
      width: 400,
      title: const Text('Enter University Email'),
      description: const Text('We use your university email '
          'to verify your student status. Be sure to check your spam folder.'),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                placeholder: Text('w.clayton@ufl.edu'),
                controller: emailController,
                enabled: formEnabled,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              ErrorController(message: _errMsg),
              const SizedBox(height: 8),
              ShadButton(
                enabled: formEnabled,
                onPressed: _onSignup,
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
