import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/app_keys.dart';
import 'package:flutter_fundamental/src/models/models.dart';
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
                    final Coin coin = snapshot.data;
                    final token = _getToken(
                        coin.privateKey, GameTab.convertMd5(coin.address));
                    final jwtHeader = {
                      HttpHeaders.authorizationHeader: 'Bearer ' + token
                    };
                    return GameWebView(headers: jwtHeader);
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
      return issueJwtHS256(
          JwtClaim(
              jwtId: jwtId,
              maxAge: const Duration(hours: 300),
              otherClaims: <String, dynamic>{
                'id': jwtId,
                'createdAt': DateTime.now().millisecondsSinceEpoch
              }),
          privateKey);
    } catch (e) {
      throw Exception(e.message);
    }
  }
}
