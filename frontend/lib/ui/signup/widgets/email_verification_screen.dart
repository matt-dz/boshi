import 'package:flutter/material.dart';
import 'package:frontend/internal/exceptions/already_verified_exception.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:frontend/ui/models/verification_code/verification_code.dart';
import '../view_model/email_verification_viewmodel.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:flutter/services.dart';
import 'package:frontend/internal/exceptions/format.dart';
import 'package:frontend/ui/core/ui/error_controller.dart';
import 'package:frontend/internal/exceptions/code_not_found_exception.dart';
import 'package:frontend/internal/exceptions/user_not_found_exception.dart';
import 'package:frontend/ui/core/ui/error_screen.dart';
import 'package:frontend/internal/logger/logger.dart';

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
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: Theme.of(context).focusColor),
                      child: VerificationForm(
                        viewModel: widget.viewModel,
                        email: widget.email,
                      ),
                    )
                  : CircularProgressIndicator(
                      color: Colors.white,
                    ),
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
  final _codeController = TextEditingController();
  bool _codeEmpty = true;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() {
        _codeEmpty = _codeController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(String code) async {
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
          if (mounted) {
            context.go('/');
          }
        }
        setState(() {
          _errMsg = formatExceptionMsg(result.error);
        });
        return;
      case Ok():
        if (mounted) {
          context.go('/');
        }
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formEnabled = !(widget.viewModel.verifyCode.running ||
        widget.viewModel.verifyCode.completed);

    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: Theme.of(context).primaryTextTheme.bodyMedium,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).focusColor),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final inputSlot = ShadInputOTPGroup(
      children: [
        ShadInputOTPSlot(
          style: Theme.of(context).primaryTextTheme.bodyMedium,
          decoration: ShadDecoration(
            labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
            focusedBorder: ShadBorder(
              top: ShadBorderSide(color: Theme.of(context).focusColor),
              bottom: ShadBorderSide(color: Theme.of(context).focusColor),
              left: ShadBorderSide(color: Theme.of(context).focusColor),
              right: ShadBorderSide(color: Theme.of(context).focusColor),
            ),
          ),
        ),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          'Verification Code',
          style: Theme.of(context)
              .primaryTextTheme
              .labelLarge
              ?.copyWith(fontSize: 24),
        ),
        Text(
          'Code sent to ${widget.email}.\n'
          'Be sure to check your spam folder.',
          textAlign: TextAlign.center,
          style: Theme.of(context).primaryTextTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Center(
          child: Pinput(
            inputFormatters: const [
              _VerificationInputFormatter(),
            ],
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            cursor: Container(
              color: Colors.white,
              width: 2,
              height: 24,
            ),
            animationCurve: Curves.linear,
            animationDuration: Duration.zero,
            onCompleted: _onSubmit,
          ),
        ),
        ErrorController(message: _errMsg),
        TTLController(
          ttl: (widget.viewModel.load.result! as Ok).value,
          viewModel: widget.viewModel,
          email: widget.email,
        ),
      ],
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
      return Text(
        'Request again in $minutesMsg and $secondsMsg',
        style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
              color: Colors.grey.shade400,
            ),
      );
    }
    return Text(
      'Request again in $secondsMsg',
      style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
            color: Colors.grey.shade400,
          ),
    );
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
      style: Theme.of(context).textButtonTheme.style,
      child: Text(
        'Request again',
        style: Theme.of(context).primaryTextTheme.bodySmall?.copyWith(
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
