import 'package:flutter/material.dart';
import 'package:frontend/ui/signup/view_model/email_register_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import '../view_model/email_verification_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:flutter/services.dart';

const verificationInputId = 'verification-input';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    super.key,
    required this.viewModel,
    required this.email,
  });

  final EmailVerificationViewModel viewModel;
  final String email;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ShadCard(
            width: 400,
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, state) {
                return VerificationForm(
                  viewModel: widget.viewModel,
                  email: widget.email,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationForm extends StatefulWidget {
  const VerificationForm({
    super.key,
    required this.viewModel,
    required this.email,
  });

  final EmailVerificationViewModel viewModel;
  final String email;

  @override
  State<VerificationForm> createState() => _VerificationForm();
}

class _VerificationForm extends State<VerificationForm> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    Widget error = SizedBox(height: 0, width: 0); // Empty space placeholder
    // to indicate no error

    final result = widget.viewModel.verifyCode.result;
    switch (result) {
      case null:
        break;
      case Ok<void>():
        context.go('/');
      case Error<void>():
        error = Text(
          result.error.toString(),
          style: TextStyle(
            color: Color.fromRGBO(255, 0, 0, 1),
            fontWeight: FontWeight.w500,
          ),
        );
    }

    return ShadForm(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShadInputOTPFormField(
            id: verificationInputId,
            maxLength: 6,
            label: const Text('Verification Code'),
            inputFormatters: const [
              _VerificationInputFormatter(),
            ],
            description: const Text('Enter your verification code.'),
            validator: (v) {
              if (v.contains(' ')) {
                return 'Fill the whole verification code';
              }
              return null;
            },
            children: const [
              ShadInputOTPGroup(
                children: [
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                ],
              ),
              Icon(size: 24, LucideIcons.dot),
              ShadInputOTPGroup(
                children: [
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                  ShadInputOTPSlot(),
                ],
              ),
            ],
          ),
          error,
          SizedBox(height: 16),
          // TODO: add use state to enable button when input
          // is filled
          ShadButton(
            width: double.infinity,
            child: Text('Enter'),
            onPressed: () async {
              if (formKey.currentState!.saveAndValidate()) {
                await widget.viewModel.verifyCode.execute(
                  VerificationCode(
                    code: formKey.currentState!.value[verificationInputId],
                    email: widget.email,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _VerificationInputFormatter extends TextInputFormatter {
  const _VerificationInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      composing: newValue.composing,
      selection: newValue.selection,
      text: newValue.text.toUpperCase(),
    );
  }
}
