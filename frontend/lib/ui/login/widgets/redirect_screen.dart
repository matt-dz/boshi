import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/oauth/oauth_repository.dart';
import 'package:frontend/utils/result.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({super.key});

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    final oauth = context.read<OAuthRepository>();
    final uri = Uri.base;

    final result = await oauth.generateSession(uri.toString());

    if (!mounted) {
      return;
    }

    if (result is Ok<void>) {
      context.go('/');
    } else {
      setState(() {
        _error = 'Failed to generate session.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text(_error ?? 'Unknown error'),
      ),
    );
  }
}
