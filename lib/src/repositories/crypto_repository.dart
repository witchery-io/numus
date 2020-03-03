import 'dart:async';

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
      return Future.error(e);
    }
  }

  Future<int> _getBalance(coin, {balance = 0, next = 20}) async {
    final Map addresses = coin.addresses(next: next);

    if (addresses.isEmpty) return Future.error('There aren\'t address');

    try {
      final balanceStream = _streamBalance(next, coin.name, addresses);
      final info = await _calcBalance(balanceStream, balance);
      if (info['checkMore']) {
        await _getBalance(coin, balance: info['balance'], next: next);
      }
      balance = info['balance'];
    } catch (e) {
      throw Exception(e);
    }

    return balance;
  }

  Stream<Balance> _streamBalance(int next, String name, Map addresses) async* {
    try {
      final to = addresses.length;
      final from = to - next;
      for (int i = from; i < to; i++) {
        yield await webClient.getBalanceByAddress(name, addresses[i].address);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map> _calcBalance(Stream<Balance> stream, balance) async {
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
