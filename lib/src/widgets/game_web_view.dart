import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameWebView extends StatelessWidget {
  final url = 'https://mighty-octopus-74.localtunnel.me/public';
  final Map<String, String> headers;

  GameWebView({this.headers});

  @override
  Widget build(BuildContext context) {
    return WebView(
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
