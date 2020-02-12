import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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
    return WebviewScaffold(
      url: "https://www.google.com",
      appBar: new AppBar(
        title: new Text("Widget webview"),
      ),
    );
  }
}
