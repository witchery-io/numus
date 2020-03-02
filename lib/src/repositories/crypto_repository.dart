import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/balance.dart';

class CryptoRepository {
  final WebClient webClient;

  const CryptoRepository({@required this.webClient});

  Future loadBalance(coin) async {
    final Map addresses = coin.addresses(next: 20);

    if (addresses.isEmpty) return Future.error('There aren\'t address');
    final balanceStream = getBalance(20, 'btc', addresses);
    final info = await sumInfo(balanceStream);

    if (info['isMore']) {
      print('is more');
    }
    
    return info['balance'];
  }

  Stream<Balance> getBalance(int to, name, addresses) async* {
    for (int i = 0; i < to; i++) {
      yield await webClient.getBalanceByAddress(name, addresses[i].address);
    }
  }

  Future<Map> sumInfo(Stream<Balance> stream) async {
    int sum = 0;
    bool isMore = false;

    try {
      await for (var value in stream) {
        sum += value.balance;
        if (value.txCount > 0) isMore = true;
      }
    } catch (e) {
      return Future.error(e.message);
    }

    return {'balance': sum, 'isMore': isMore};
  }
}
