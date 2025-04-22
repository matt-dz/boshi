import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  final _iconSize = 25.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShadDivider.horizontal(
          margin: EdgeInsets.zero,
          color: Theme.of(context).dividerColor,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 150,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.house, size: _iconSize),
                      onPressed: () {
                        context.go('/');
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        PhosphorIconsRegular.plusCircle,
                        size: _iconSize,
                      ),
                      onPressed: () {
                        context.go('/create');
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.user, size: _iconSize),
                      onPressed: () {
                        context.go('/profile');
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
