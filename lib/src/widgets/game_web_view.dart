import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/utils/message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef onDeepLinkEvent = Function(String deepLink);

class GameWebView extends StatelessWidget {
  final baseUrl = 'http://192.168.0.136:8080/public';
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
        navigationDelegate: (NavigationRequest action) async {
          final url = action.url;
          final isLink = url.contains(RegExp("^(http|https)://"), 0);
          final isOwnerLink =
              url.contains(RegExp("https://m.avocado.casino"), 0);

          if (!isLink)
            onDeepLink(action.url);
          else if (isOwnerLink)
            return NavigationDecision.navigate;
          else if (await canLaunch(url))
            await launch(url);
          else
            Message.show(context, 'Link is not valid');

          return Future.value(null);
        });
  }
}
