import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: Colors.red,
        fontSize: 14,
        height: 0.7,
      ),
    );
  }
}
