import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../view_model/email_register_viewmodel.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:frontend/ui/core/ui/error_controller.dart';
import 'package:frontend/internal/exceptions/format.dart';

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
  final _emailController = TextEditingController();
  bool _emailEmpty = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _emailEmpty = _emailController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
        await widget.viewModel.addEmail.execute(_emailController.text);
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
      '${Uri.encodeComponent(_emailController.text)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final formEnabled = !(widget.viewModel.addEmail.running ||
        widget.viewModel.addEmail.completed);
    return ShadCard(
      width: 400,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      border: Border.all(color: Theme.of(context).focusColor),
      title: Text(
        'Enter University Email',
        style: Theme.of(context).primaryTextTheme.labelLarge,
      ),
      description: Text(
        'We use your university email '
        'to verify your student status. Be sure to check your spam folder.',
        style: Theme.of(context).primaryTextTheme.labelSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF223C48),
                  contentPadding: EdgeInsets.all(12),
                  isDense: true,
                  hintStyle: Theme.of(context)
                      .primaryTextTheme
                      .bodySmall
                      ?.copyWith(color: Color(0xff6f748c)),
                  hintText: 'w.clayton@ufl.edu',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                ),
                style: Theme.of(context).primaryTextTheme.bodySmall,
                cursorColor:
                    Theme.of(context).primaryTextTheme.bodySmall?.color,
                controller: _emailController,
                enabled: formEnabled,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              ErrorController(message: _errMsg),
              const SizedBox(height: 8),
              TextButton(
                onPressed: (_emailEmpty || !formEnabled) ? null : _onSignup,
                style: Theme.of(context).textButtonTheme.style?.copyWith(
                  side: WidgetStateProperty.resolveWith((states) {
                    return BorderSide(
                      width: 2,
                      color: states.contains(WidgetState.disabled)
                          ? Color(0xFF636363)
                          : Color(0xffa0cafa),
                    );
                  }),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.disabled)
                        ? Colors.transparent
                        : Color(0xff63a0eb);
                  }),
                ),
                child: Text(
                  'Enter',
                  style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
                        color: (_emailEmpty || !formEnabled)
                            ? Colors.grey.shade600
                            : null,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
