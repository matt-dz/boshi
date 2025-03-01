import 'package:flutter/material.dart';

import 'package:atproto/atproto.dart' as atp;
import 'package:atproto/atproto_oauth.dart';
import 'package:go_router/go_router.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key, required this.atpSession});

  final atp.ATProto? atpSession;

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (widget.atpSession != null) context.go("/");
      } on OAuthException {
        rethrow;
      }
    });

    return Center(
      child: const Text("Redirecting...",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            decoration: TextDecoration.none,
          )),
    );
  }
}
