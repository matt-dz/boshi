import 'package:flutter/material.dart';
import 'package:frontend/shared/exceptions/already_verified_exception.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import '../view_model/email_verification_viewmodel.dart';
import 'package:frontend/utils/result.dart';
import 'package:flutter/services.dart';
import 'package:frontend/exceptions/format.dart';
import 'package:frontend/ui/core/ui/error.dart' as error_widget;
import 'package:frontend/shared/exceptions/code_not_found_exception.dart';
import 'package:frontend/shared/exceptions/user_not_found_exception.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
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
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, state) {
        logger.d('refreshed');
        if (widget.viewModel.load.error) {
          final err = widget.viewModel.load.result! as Error;
          switch (err.error) {
            case UserNotFoundException():
            case CodeNotFoundException():
              context.go('/signup');
            default:
              print(err.error);
              return ErrorScreen(
                message: formatExceptionMsg(err.error),
                onRefresh: widget.viewModel.reload,
              );
          }
        }
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: widget.viewModel.load.completed
                  ? ShadCard(
                      width: 400,
                      child: VerificationForm(
                        viewModel: widget.viewModel,
                        email: widget.email,
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        );
      },
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
    final formEnabled = !(widget.viewModel.verifyCode.running ||
        widget.viewModel.verifyCode.completed);
    return ShadForm(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShadInputOTPFormField(
            enabled: formEnabled,
            id: verificationInputId,
            maxLength: 6,
            label: const Text('Verification Code'),
            inputFormatters: const [
              _VerificationInputFormatter(),
            ],
            description: const Text('Enter your verification code. '
                'Be sure to check your junk folder.'),
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
            enabled: formEnabled,
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

                if (!context.mounted) {
                  return;
                }

                switch (result) {
                  case Error():
                    if (result.error is AlreadyVerifiedException) {
                      context.go('/');
                    }
                    setState(() {
                      _errMsg = formatExceptionMsg(result.error);
                    });
                  default:
                    break;
                }
              }
            },
          ),
          SizedBox(height: 8),
          TTLController(
            ttl: (widget.viewModel.load.result! as Ok).value,
            viewModel: widget.viewModel,
            email: widget.email,
          ),
        ],
      ),
    );
  }
}

class TTLController extends StatefulWidget {
  const TTLController({
    super.key,
    required this.ttl,
    required this.viewModel,
    required this.email,
  });
  final double ttl;
  final EmailVerificationViewModel viewModel;
  final String email;

  @override
  State<TTLController> createState() => _TTLController();
}

class _TTLController extends State<TTLController> {
  late double _ttl;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ttl = widget.ttl;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_ttl <= 0) {
        timer.cancel();
        return;
      }

      setState(() {
        _ttl = _ttl - 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ttl > 0
        ? TTLTimer(ttl: _ttl)
        : RequestCodeButton(viewModel: widget.viewModel, email: widget.email);
  }
}

class TTLTimer extends StatelessWidget {
  const TTLTimer({super.key, required this.ttl});

  final double ttl;

  @override
  Widget build(BuildContext context) {
    final minutes = ttl ~/ 60;
    final seconds = ttl % 60;
    String minutesMsg = '';
    String secondsMsg = '';

    if (minutes >= 2) {
      minutesMsg = '$minutes minutes';
    } else if (minutes == 1) {
      minutesMsg = '$minutes minute';
    }

    if (seconds != 1) {
      secondsMsg = '$seconds seconds';
    } else {
      secondsMsg = '$seconds second';
    }

    if (minutesMsg.isNotEmpty) {
      return Text('Request again in $minutesMsg and $secondsMsg');
    }
    return Text('Request again in $secondsMsg');
  }
}

class RequestCodeButton extends StatefulWidget {
  const RequestCodeButton({
    super.key,
    required this.viewModel,
    required this.email,
  });

  final EmailVerificationViewModel viewModel;
  final String email;

  @override
  State<RequestCodeButton> createState() => _RequestCodeButtonState();
}

class _RequestCodeButtonState extends State<RequestCodeButton> {
  void _handleResendCode() async {
    final result = await widget.viewModel.resendCode.execute(widget.email);
    if (!mounted) {
      return;
    }

    switch (result) {
      case Ok<void>():
        showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Code sent'),
            content: const Text('Please check your email for '
                'the verification code.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      case Error<void>():
        showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unable to send code'),
            content: Text(formatExceptionMsg(result.error)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.viewModel.resendCode.running ? null : _handleResendCode,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        'Request again',
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
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
