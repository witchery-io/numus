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

  Future loadBalanceByAddress(coin,
      {balance = BALANCE, start = START, end = END}) async {
    final bal = await _addressesSynchronization(coin, balance, start, end);
    if (bal['isRec'])
      await loadBalanceByAddress(coin,
          balance: bal['blc'], start: start + ADDING, end: end + ADDING);

    return Future.value(bal['blc']);
  }

  Future<Map> _addressesSynchronization(
      coin, balance, startIndex, endIndex) async {
    bool isRec = false;
    final List addresses =
        await coin.addresses(start: startIndex, end: endIndex);

    if (addresses.isNotEmpty) {
      for (int i = startIndex; i < endIndex; i++) {
        try {
          Balance b = await webClient.getBalanceByAddress(
              coin.name, addresses[i].address);
          balance += b.balance;
          if (b.txCount > 0) isRec = true;
        } catch (e) {
          throw Exception(e.message);
        }
      }
    }
    return {'blc': balance, 'isRec': isRec};
  }
}
