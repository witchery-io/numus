import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameWebView extends StatelessWidget {
  final url = 'https://mighty-octopus-74.localtunnel.me/public';
  final Map<String, String> headers;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  GameWebView({this.headers});

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        webViewController.loadUrl(url, headers: headers);
        _controller.complete(webViewController);
      },
    );
  }
}
