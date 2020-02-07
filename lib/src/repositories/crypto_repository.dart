import 'package:flutter_fundamental/core/core.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  WebClient webClient;

  CryptoRepository() {
    webClient = WebClient(httpClient: http.Client());
  }

  Future loadBalanceByAddress() async {
    return await webClient.getBalanceByAddress();
  }
}
