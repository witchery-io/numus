import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameWebView extends StatelessWidget {
  final url = 'https://531bd96c.ngrok.io/public';
  final Map<String, String> headers;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  GameWebView({Key key, this.headers}) : super(key: key);

  get webView => WebView(
    initialUrl: url,
    gestureNavigationEnabled: true,
    javascriptMode: JavascriptMode.unrestricted,
    onWebViewCreated: (WebViewController webViewController) async {
      await webViewController.loadUrl(url, headers: headers);
      _controller.complete(webViewController);
    },
    debuggingEnabled: true,
    navigationDelegate: (NavigationRequest action) {
      final isLink = action.url.contains(RegExp("^(http|https)://"), 0);
      if (isLink) return NavigationDecision.navigate;

      return Future.value(null);
    },
  );

  @override
  Widget build(BuildContext context) {
    return webView;
  }
}
