import 'package:flutter/material.dart';

class GameTab extends StatefulWidget {
  final List currencies;

  GameTab({this.currencies});

  @override
  _GameTabState createState() => _GameTabState();
}

class _GameTabState extends State<GameTab> {
  @override
  void initState() {
    print('init state');
    print(widget.currencies);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('1');
  }
}
