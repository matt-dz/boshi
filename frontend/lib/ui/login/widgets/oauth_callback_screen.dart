import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/atproto/atproto_repository.dart';
import 'package:frontend/internal/result/result.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class OAuthCallback extends StatefulWidget {
  const OAuthCallback({super.key});

  @override
  State<OAuthCallback> createState() => _OAuthCallbackState();
}

class _OAuthCallbackState extends State<OAuthCallback> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    final oauth = context.read<AtProtoRepository>();

    final result = await oauth.generateSession(Uri.base.toString());

    if (!mounted) {
      return;
    }

    if (result is Ok<void>) {
      context.go('/');
    } else {
      setState(() {
        print(result.toString());
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
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
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
