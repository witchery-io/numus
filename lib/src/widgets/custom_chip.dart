import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final int index;
  final String title;

  CustomChip({@required this.index, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade800, child: Text('$index')),
      label: Text('$title'),
    );
  }
}
