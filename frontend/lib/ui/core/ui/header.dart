import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/utils/logger.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: TextButton(
            child: Text(
              'Boshi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              logger.d('Boshi pressed!');
            },
          ),
        ),
        ShadDivider.horizontal(margin: EdgeInsets.zero),
      ],
    );
  }
}
