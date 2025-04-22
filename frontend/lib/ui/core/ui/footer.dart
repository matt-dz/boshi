import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/internal/logger/logger.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final _iconSize = 25.0;

  @override
  Widget build(BuildContext context) {
    final currentPath = ModalRoute.of(context)?.settings.name;
    logger.d('current path: $currentPath');

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
                      icon: Icon(
                        currentPath == 'home'
                            ? PhosphorIconsFill.house
                            : PhosphorIconsRegular.house,
                        size: _iconSize,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () {
                        context.go('/');
                        setState(() {});
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        currentPath == 'create'
                            ? PhosphorIconsFill.plusCircle
                            : PhosphorIconsRegular.plusCircle,
                        size: _iconSize,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () {
                        context.go('/create');
                        setState(() {});
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        currentPath == 'profile'
                            ? PhosphorIconsFill.user
                            : PhosphorIconsRegular.user,
                        size: _iconSize,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () {
                        context.go('/profile');
                        setState(() {});
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
