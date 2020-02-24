import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:http/http.dart' as http;

class WebClient {
  final http.Client httpClient;
  final baseUrl = "https://c000bb8f.ngrok.io/public";

  const WebClient({@required this.httpClient});

  Future<Balance> getBalanceByAddress(String currency, String address) async {
    http.Response response = await httpClient
        .get("$baseUrl/$currency/test/address/$address/balance");
    if (response.statusCode == 200) {
      return Balance.fromJson(json.decode(response.body));
    } else {
      final msg = '[$currency]: ${json.decode(response.body)['message']}';
      throw Exception(msg);
    }
  }
}
