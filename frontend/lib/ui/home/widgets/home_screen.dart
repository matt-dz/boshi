import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/oauth.dart';
import 'package:provider/provider.dart';

import 'package:frontend/ui/core/ui/header.dart';
import 'package:frontend/ui/core/ui/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(title: widget.title),
          Expanded(
            child: Center(
              child:
                  Consumer<OAuthRepository>(builder: (context, oauth, child) {
                if (oauth.atProtoSession != null) {
                  return Text(
                      'Your session: ${oauth.atProtoSession?.identity}',);
                } else {
                  oauth.refreshSession();
                  return Text('Please sign in.');
                }
              },),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
