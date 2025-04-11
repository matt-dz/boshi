import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../view_model/email_register_viewmodel.dart';

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
        child: Center(
          child: SignupForm(),
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();

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
                id: 'email',
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
              const SizedBox(height: 16),
              ShadButton(
                child: const Text('Enter'),
                onPressed: () async {
                  if (formKey.currentState!.saveAndValidate()) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
