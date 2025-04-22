import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/internal/logger/logger.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: TextButton(
            child: Text(
              'Boshi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC9C9D9),
              ),
            ),
            onPressed: () {
              logger.d('Boshi pressed!');
            },
          ),
        ),
        ShadDivider.horizontal(
          margin: EdgeInsets.zero,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
