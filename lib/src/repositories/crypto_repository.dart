import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/balance.dart';

class CryptoRepository {
  final WebClient webClient;

  const CryptoRepository({@required this.webClient});

  Future<int> loadBalance(coin) async => getBalance(coin);

  Future<int> getBalance(coin, {balance = 0, next = 20}) async {
    final Map addresses = coin.addresses(next: next);

    if (addresses.isEmpty) return Future.error('There aren\'t address');

    final balanceStream = streamBalance(next, coin.name, addresses);
    final info = await calcBalance(balanceStream, balance);

    if (info['checkMore']) {
      await getBalance(coin, balance: info['balance'], next: next);
    }

    return info['balance'];
  }

  Stream<Balance> streamBalance(int next, String name, Map addresses) async* {
    final to = addresses.length;
    final from = to - next;
    for (int i = from; i < to; i++) {
      yield await webClient.getBalanceByAddress(name, addresses[i].address);
    }
  }

  Future<Map> calcBalance(Stream<Balance> stream, balance) async {
    bool checkMore = false;

    try {
      await for (var value in stream) {
        balance += value.balance;
        if (value.txCount > 0) checkMore = true;
      }
    } catch (e) {
      return Future.error(e.message);
    }

    return {'balance': balance, 'checkMore': checkMore};
  }
}
