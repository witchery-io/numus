import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/balance.dart';

const START = 0;
const END = 20;
const ADDING = 20;
const BALANCE = 0;

class CryptoRepository {
  final WebClient webClient;

  const CryptoRepository({@required this.webClient});

  Future<int> loadBalance(coin,
      {balance = BALANCE, start = START, end = END}) async {
    int result = 0;
    try {
      final info = await _addressesSynchronization(coin, balance, start, end);

      if (info['isRec']) {
        await loadBalance(coin,
            balance: info['blc'], start: start + ADDING, end: end + ADDING);
      }

      result = info['blc'];
    } catch (e) {
      return Future.error('${e.message}');
    }

    return result;
  }

  Future<Map> _addressesSynchronization(
      coin, balance, startIndex, endIndex) async {
    bool isRec = false;
    coin.addressSynchronization(start: startIndex, end: endIndex);
    final List addresses = coin.cacheAddresses;

    if (addresses.isEmpty) {
      throw Exception('There aren\'t address');
    }

    for (int i = startIndex; i < endIndex; i++) {
      try {
        Balance result = await webClient.getBalanceByAddress(
            coin.name, addresses[i].address);
        balance += result.balance;
        if (result.txCount > 0) {
          isRec = true;
        }
      } catch (e) {
        if (e is UnimplementedError) {
          //// implementing connection
        }

        throw Exception(e.message);
      }
    }

    return {'blc': balance, 'isRec': isRec};
  }
}
