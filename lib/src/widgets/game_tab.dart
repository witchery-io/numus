import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/app_keys.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/utils/message.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class GameTab extends StatelessWidget {
  final List<Future<Coin>> currencies;

  static String convertMd5(String val) {
    return md5.convert(utf8.encode(val)).toString();
  }

  GameTab({Key key, this.currencies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: currencies == null
            ? GameWebView()
            : FutureBuilder(
                future: currencies.first,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text('Ups!'));

                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      var jwtHeader;
                      final Coin coin = snapshot.data;
                      final md5Address = GameTab.convertMd5(coin.address);
                      try {
                        final token = _getToken(coin.privateKey, md5Address);
                        jwtHeader = {
                          HttpHeaders.authorizationHeader: 'Bearer ' + token
                        };
                      } catch (e) {
                        Message.show(context, e.message);
                      }
                      return GameWebView(
                          key: AppKeys.gameWebView, headers: jwtHeader);
                    case ConnectionState.waiting:
                      return LoadingIndicator(
                          key: AppKeys.statsLoadingIndicator);
                    default:
                      return Container(key: AppKeys.emptyDetailsContainer);
                  }
                }));
  }

  String _getToken(String privateKey, String jwtId) {
    try {
      return issueJwtHS256(
          JwtClaim(
              jwtId: jwtId,
              maxAge: const Duration(hours: 300),
              otherClaims: <String, dynamic>{
                'id': jwtId,
                'createdAt': DateTime.now().millisecondsSinceEpoch,
              }),
          privateKey);
    } catch (e) {
      throw Exception(e.message);
    }
  }
}
