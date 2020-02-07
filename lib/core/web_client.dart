import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WebClient {
  final http.Client httpClient;

  WebClient({@required this.httpClient});

  Future getBalanceByAddress() {
    return httpClient.get('');
  }
}
