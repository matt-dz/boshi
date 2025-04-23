import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget that displays the header.
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            child: Text(
              'Boshi',
              style: GoogleFonts.monoton(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).focusColor,
              ),
            ),
            onPressed: () {
              if (context.mounted) {
                context.go('/');
              }
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
