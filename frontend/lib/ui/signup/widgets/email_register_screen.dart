import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../view_model/email_register_viewmodel.dart';
import 'package:frontend/utils/result.dart';

const emailId = 'email';

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
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    Widget error = SizedBox(height: 0, width: 0); // Empty space placeholder
    // to indicate no error

    final result = widget.viewModel.addEmail.result;
    switch (result) {
      case null:
        break;
      case Ok<void>():
        context.go(
          '/signup/verify?email='
          '${Uri.encodeComponent(_email)}',
        );
      case Error<void>():
        final err = result.error.toString();
        final text = err.substring(err.indexOf(' ') + 1);
        error = Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(255, 0, 0, 1),
            fontWeight: FontWeight.w500,
          ),
        );
    }

    return ShadCard(
      width: 400,
      title: const Text('Enter University Email'),
      description: const Text('We use your university email '
          'to verify your student status. We will never sell your data.'),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                enabled: !widget.viewModel.addEmail.running,
                keyboardType: TextInputType.emailAddress,
                id: emailId,
                placeholder: const Text('wcj@ufl.edu'),
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Email must not be empty.';
                  }
                  if (!v.endsWith('.edu')) {
                    return 'Email must end in .edu';
                  }
                  return null;
                },
              ),
              error,
              const SizedBox(height: 16),
              ShadButton(
                enabled: !widget.viewModel.addEmail.running,
                onPressed: () async {
                  if (formKey.currentState!.saveAndValidate()) {
                    setState(() {
                      _email = formKey.currentState!.value[emailId];
                    });
                    await widget.viewModel.addEmail
                        .execute(formKey.currentState!.value[emailId]);
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
