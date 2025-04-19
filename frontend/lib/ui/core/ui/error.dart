import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({super.key, required this.message, this.color});

  final String message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: color ?? Colors.red,
        fontSize: 14,
      ),
    );
  }
}
