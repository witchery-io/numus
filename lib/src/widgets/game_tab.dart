import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/widgets/loading_indicator.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class GameTab extends StatelessWidget {
  final List<Future<Coin>> currencies;

  static String convertMd5(String val) {
    return md5.convert(utf8.encode(val)).toString();
  }

  GameTab({this.currencies});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // error
      future: currencies.first,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Coin coin = snapshot.data;
          final url = 'https://m.avocado.casino';
          final token =
              _getToken(coin.privateKey, GameTab.convertMd5(coin.address));
          final jwtHeader = {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          };
          return SafeArea(
            child: WebviewScaffold(
                url: url,
                headers: jwtHeader,
                initialChild: Center(child: Text('Loading...'))),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        } else if (snapshot.connectionState == ConnectionState.none) {
          print('NONE');
        }

        return Text('Loading...');
      },
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
