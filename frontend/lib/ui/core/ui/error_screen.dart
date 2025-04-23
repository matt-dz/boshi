import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'error.dart';

/// A widget that displays an error message and a refresh button.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  final String message;
  final FutureOr<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Error(message: message, color: Colors.black),
              IconButton(
                icon: Icon(LucideIcons.rotateCcw),
                onPressed: onRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
