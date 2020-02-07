import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/models.dart';

class CryptoRepository {
  final WebClient webClient;

  const CryptoRepository({@required this.webClient});

  Future<Balance> loadBalanceByAddress(String currency, String address) async {
    return await webClient.getBalanceByAddress(currency, address);
  }
}
