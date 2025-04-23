import 'package:flutter/material.dart';

/// A widget that displays an error message.
class Error extends StatelessWidget {
  const Error({super.key, required this.message, this.color});

	/// Message to display
  final String message;

	/// Color of the message
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Text(
        textAlign: TextAlign.center,
        message,
        style: TextStyle(
          color: color ?? Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }
}
