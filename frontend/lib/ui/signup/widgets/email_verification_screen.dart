import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import '../view_model/email_verification_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:flutter/services.dart';
import 'package:frontend/exceptions/format.dart';
import 'package:frontend/ui/core/ui/error.dart' as error_widget;
import 'package:frontend/utils/logger.dart';

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
  late Future<double> _ttl;
  String? _errMsg;

  @override
  void initState() {
    super.initState();
    _ttl = _getCodeTTL();
  }

  Future<double> _getCodeTTL() async {
    final result = await widget.viewModel.getCodeTTL();
    if (!mounted) {
      return 0.0;
    }

    switch (result) {
      case Ok<double>():
        logger.d(result.value);
        return result.value;
      case Error<double>():
        print(result.error.toString());
        context.go('/error');
        return 0.0;
    }
  }

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
          FutureBuilder<double>(
            future: _ttl,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TTLTimer(ttl: snapshot.data!);
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Unable to retrieve TTL');
              }

              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

class TTLTimer extends StatefulWidget {
  const TTLTimer({super.key, required this.ttl});
  final double ttl;

  @override
  State<TTLTimer> createState() => _TTLTimer();
}

class _TTLTimer extends State<TTLTimer> {
  late double _ttl;

  @override
  void initState() {
    super.initState();
    _ttl = widget.ttl;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_ttl == 0) {
        timer.cancel();
        return;
      }

      setState(() {
        _ttl--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ttl <= 0) {
      return ShadButton(
        child: Text('Request again'),
      );
    }

    return Text('Request another code in $_ttl seconds');
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
