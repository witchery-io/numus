import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef onDeepLink = Function(String deepLink);

class GameWebView extends StatelessWidget {
  final url = 'https://531bd96c.ngrok.io/public';
  final Map<String, String> headers;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final onDeepLink deepLink;

  GameWebView({Key key, this.deepLink, this.headers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
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

          deepLink(action.url);

          return Future.value(null);
        });
  }
}
