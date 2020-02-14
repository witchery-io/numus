import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/app_keys.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/widgets/loading_indicator.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameTab extends StatelessWidget {
  final List<Future<Coin>> currencies;

  static String convertMd5(String val) {
    return md5.convert(utf8.encode(val)).toString();
  }

  GameTab({this.currencies});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: currencies == null
          ? _GameWebView()
          : FutureBuilder(
              future: currencies.first,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text('Ups!'));

                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    final Coin coin = snapshot.data;
                    final token = _getToken(
                        coin.privateKey, GameTab.convertMd5(coin.address));
                    final jwtHeader = {
                      HttpHeaders.authorizationHeader: 'Bearer ' + token
                    };
                    return _GameWebView(headers: jwtHeader);
                  case ConnectionState.waiting:
                    return LoadingIndicator(key: AppKeys.statsLoadingIndicator);
                  default:
                    return Container(key: AppKeys.emptyDetailsContainer);
                }
              }),
    );
  }

  String _getToken(String privateKey, String jwtId) {
    try {
      final claimSet = JwtClaim(
          jwtId: jwtId,
          maxAge: const Duration(hours: 300),
          otherClaims: <String, dynamic>{
            'id': jwtId,
            'createdAt': DateTime.now().millisecondsSinceEpoch
          });
      return issueJwtHS256(claimSet, privateKey);
    } catch (e) {
      throw Exception(e.message);
    }
  }
}

class _GameWebView extends StatefulWidget {
  final Map<String, String> headers;

  _GameWebView({this.headers});

  @override
  __GameWebViewState createState() => __GameWebViewState();
}

class __GameWebViewState extends State<_GameWebView> {
  final url = 'https://mighty-octopus-74.localtunnel.me/public';

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
