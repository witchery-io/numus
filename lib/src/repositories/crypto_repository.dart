import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/balance.dart';

class CryptoRepository {
  final WebClient webClient;

  const CryptoRepository({@required this.webClient});

  Future loadBalance(coin) async {
    try {
      return await _getBalance(coin);
    } catch (e) {
      return Future.error(e.message);
    }
  }

  Future<int> _getBalance(coin, {balance = 0, next = 20}) async {
    int sumBalance = 0;
    final Map addresses = coin.addresses(next: next);

    if (addresses.isEmpty) throw Exception('There aren\'t address');

    try {
      final balanceStream = _streamBalance(next, coin.name, addresses);
      final info = await _calcBalance(balanceStream, balance);

      if (info['checkMore'])
        await _getBalance(coin, balance: info['balance'], next: next);

      sumBalance = info['balance'];
    } on SocketException catch (e) {
      Future.delayed(Duration(seconds: 10), () => loadBalance(coin));

      throw Exception(e.osError.message);
    } catch (e) {
      throw Exception(e.message);
    }

    return sumBalance;
  }

  Stream<Balance> _streamBalance(int next, String name, Map addresses) async* {
    final to = addresses.length;
    final from = to - next;
    for (int i = from; i < to; i++) {
      yield await webClient.getBalanceByAddress(name, addresses[i].address);
    }
  }

  Future<Map> _calcBalance(Stream<Balance> stream, balance) async {
    bool checkMore = false;

    await for (var info in stream) {
      balance += info.balance;
      if (info.txCount > 0) checkMore = true;
    }

    return {'balance': balance, 'checkMore': checkMore};
  }
}
