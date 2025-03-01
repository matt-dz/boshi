import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Header extends StatefulWidget {
  const Header({super.key, required this.title});

  final String title;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: TextButton(
              child: Text('Boshi',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
              onPressed: () {
                print('Boshi pressed!');
              },
            ),),
        ShadDivider.horizontal(margin: EdgeInsets.zero),
      ],
    );
  }
}
