import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/core/http_provider.dart';
import 'package:http/http.dart' as http;

class WebClient implements HttpProvider {
  final http.Client httpClient;
  final baseUrl = "http://192.168.0.136:8080/public";

  const WebClient({@required this.httpClient});

  @override
  Future<Balance> getBalanceByAddress(String currency, String address) async {
    final url = "$baseUrl/$currency/test/address/$address/balance";
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      return Balance.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  @override
  Future<Balance> getBalance(String curr, String address) async {
    final url = "$baseUrl/$curr/test/address/$address";
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      return Balance.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  @override
  Future pushTransaction(String curr, String txHex) async {
    final response = await httpClient.post(
        "$baseUrl/$curr/test/transactions/send",
        body: json.encode({'rowTransaction': txHex}),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
