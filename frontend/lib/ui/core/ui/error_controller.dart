import 'package:flutter/material.dart';
import 'error.dart';

/// A widget that displays that determines whether to display an error.
class ErrorController extends StatelessWidget {
  const ErrorController({
    super.key,
    this.message,
  });

	/// Message to display
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
