import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import '../view_model/email_verification_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:flutter/services.dart';
import 'package:frontend/exceptions/format.dart';
import 'package:frontend/ui/core/ui/error.dart' as error_widget;

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
  final _formKey = GlobalKey<ShadFormState>();
  String? _errMsg;

  @override
  Widget build(BuildContext context) {
    switch (widget.viewModel.verifyCode.result) {
      case Ok<void>():
        context.go('/');
      default:
        break;
    }

    return ShadForm(
      key: _formKey,
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
          SizedBox(height: 8),
          error_widget.Error(
            message: _errMsg ?? '',
          ),
          SizedBox(height: 8),
          ShadButton(
            width: double.infinity,
            child: Text('Enter'),
            onPressed: () async {
              setState(() {
                _errMsg = null;
              });
              if (_formKey.currentState!.saveAndValidate()) {
                final String code =
                    _formKey.currentState!.value[verificationInputId];
                if (code.contains(' ')) {
                  setState(() {
                    _errMsg = 'Must fill all fields of code';
                  });
                  return;
                }
                final result = await widget.viewModel.verifyCode.execute(
                  VerificationCode(
                    code: code,
                    email: widget.email,
                  ),
                );

                if (result is Error<void>) {
                  setState(() {
                    _errMsg = formatExceptionMsg(result.error);
                  });
                }
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
