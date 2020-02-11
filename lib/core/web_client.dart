import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:http/http.dart' as http;

class WebClient {
  final http.Client httpClient;
  final _baseUrl = "https://a9985d07.ngrok.io/public";

  const WebClient({@required this.httpClient});

  Future<Balance> getBalanceByAddress(String currency, String address) async {
    http.Response response = await httpClient
        .get("$_baseUrl/$currency/test/address/$address/balance");
    if (response.statusCode == 200) {
      return Balance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load balance of address');
    }
  }
}
