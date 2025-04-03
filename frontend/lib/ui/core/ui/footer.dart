import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:frontend/utils/logger.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  final _iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShadDivider.horizontal(),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 450,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.house, size: _iconSize),
                      onPressed: () {
                        logger.d('pencil pressed!');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        PhosphorIconsRegular.graduationCap,
                        size: _iconSize,
                      ),
                      onPressed: () {
                        logger.d('school pressed!');
                      },
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: CircleBorder(),
                      ),
                      icon: Icon(
                        PhosphorIconsRegular.plus,
                        size: _iconSize,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        logger.d('plus pressed!');
                      },
                    ),
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.bell, size: _iconSize),
                      onPressed: () {
                        logger.d('bell pressed!');
                      },
                    ),
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.user, size: _iconSize),
                      onPressed: () {
                        logger.d('person pressed!');
                      },
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
