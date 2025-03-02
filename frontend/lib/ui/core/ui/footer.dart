import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
                        print('pencil pressed!');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        PhosphorIconsRegular.graduationCap,
                        size: _iconSize,
                      ),
                      onPressed: () {
                        print('school pressed!');
                      },
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            PhosphorIconsRegular.plus,
                            color: Colors.white,
                            size: _iconSize,
                          ),
                          onPressed: () {
                            print('plus pressed!');
                          },
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.bell, size: _iconSize),
                      onPressed: () {
                        print('bell pressed!');
                      },
                    ),
                    IconButton(
                      icon: Icon(PhosphorIconsRegular.user, size: _iconSize),
                      onPressed: () {
                        print('person pressed!');
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
