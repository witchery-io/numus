import 'package:flutter_fundamental/core/core.dart';

class CryptoRepository {
  final WebClient webClient;

  const CryptoRepository({
    this.webClient = const WebClient(),
  });

  Future loadBalanceByAddress() async {
    return await webClient.getBalanceByAddress();
  }
}
