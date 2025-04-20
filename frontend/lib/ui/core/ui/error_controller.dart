import 'package:flutter/material.dart';
import 'error.dart';

class ErrorController extends StatelessWidget {
  const ErrorController({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final localMsg = message;
    if (localMsg == null) {
      return Container();
    }

    return Error(message: localMsg);
  }
}
