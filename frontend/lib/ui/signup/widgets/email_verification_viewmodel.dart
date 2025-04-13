import 'package:flutter/material.dart';
import 'package:frontend/ui/signup/view_model/email_register_viewmodel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import '../view_model/email_verification_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:flutter/services.dart';

const verificationInputId = 'verification-input';

class VerificationInputFormatter extends TextInputFormatter {
  const VerificationInputFormatter();

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
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return Scaffold(
              body: SafeArea(
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) {
                    return Center(
                      child: ShadCard(
                        width: 400,
                        child: VerificationForm(
                          viewModel: widget.viewModel,
                          email: widget.email,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VerificationForm extends StatelessWidget {
  const VerificationForm({
    super.key,
    required this.viewModel,
    required this.email,
  });

  final EmailVerificationViewModel viewModel;
  final String email;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
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
              VerificationInputFormatter(),
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
          SizedBox(height: 16),
          // TODO: add use state to enable button when input
          // is filled
          ShadButton(
            width: double.infinity,
            child: Text('Enter'),
            onPressed: () async {
              if (formKey.currentState!.saveAndValidate()) {
                await viewModel.verifyCode.execute(
                  VerificationCode(
                    code: formKey.currentState!.value[verificationInputId],
                    email: email,
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
