import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/balance.dart';

class CryptoRepository {
  int balance = 0;
  final WebClient webClient;

  CryptoRepository({@required this.webClient});

  Future loadBalance(coin) async {
    try {
      return await _getBalance(coin);
    } catch (e) {
      return Future.error(e.message);
    }
  }

  Future<int> _getBalance(coin, {next = 20}) async {
    final Map addresses = coin.addresses(next: next);

    if (addresses.isEmpty) throw Exception('There aren\'t address');

    try {
      final balanceStream = _streamBalance(next, coin.name, addresses);
      final info = await _calcBalance(balanceStream);

      if (!info.checkMore) return balance;

      await _getBalance(coin, next: next);
    } on SocketException catch (e) {
      Future.delayed(Duration(seconds: 10), () => loadBalance(coin));

      throw Exception(e.osError.message);
    } catch (e) {
      throw Exception(e.message);
    }

    throw Exception('Loop balance worning');
  }

  Stream<Balance> _streamBalance(int next, String name, Map addresses) async* {
    final to = addresses.length;
    final from = to - next;
    for (int i = from; i < to; i++) {
      yield await webClient.getBalanceByAddress(name, addresses[i].address);
    }
  }

  Future<CalcBalanceArgs> _calcBalance(Stream<Balance> stream) async {
    bool checkMore = false;

    await for (var info in stream) {
      balance += info.balance;
      if (info.txCount > 0) checkMore = true;
    }

    return CalcBalanceArgs(checkMore);
  }
}

class CalcBalanceArgs {
  final bool checkMore;

  CalcBalanceArgs(this.checkMore);
}
