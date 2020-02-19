import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef onDeepLinkEvent = Function(String deepLink);

class GameWebView extends StatelessWidget {
  final baseUrl = 'https://08a3dda6.ngrok.io/public';
  final Map<String, String> headers;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final onDeepLinkEvent onDeepLink;

  GameWebView({Key key, this.onDeepLink, this.headers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl: baseUrl,
        gestureNavigationEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
          await webViewController.loadUrl(baseUrl, headers: headers);
          _controller.complete(webViewController);
        },
        debuggingEnabled: true,
        navigationDelegate: (NavigationRequest action) {
          final isLink = action.url.contains(RegExp("^(http|https)://"), 0);
          if (isLink) return NavigationDecision.navigate;

          onDeepLink(action.url);

          return Future.value(null);
        });
  }
}
