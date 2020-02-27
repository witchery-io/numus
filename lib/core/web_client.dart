import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:http/http.dart' as http;

class WebClient {
  final http.Client httpClient;
  final baseUrl = "https://7af18e82.ngrok.io/public";

  const WebClient({@required this.httpClient});

  Future<Balance> getBalanceByAddress(String currency, String address) async {
    final url = "$baseUrl/$currency/test/address/$address/balance";
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      return Balance.fromJson(json.decode(response.body));
    } else if (response.statusCode == 304) {
      /// there is not new updates
      return null;
    }  else if (response.statusCode > 500) {
      throw UnimplementedError('Initialization...');
    }  else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
