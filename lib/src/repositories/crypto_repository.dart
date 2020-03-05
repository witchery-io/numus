import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/models/balance.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/providers/providers.dart';

class CryptoRepository {
  final WebClient webClient;
  final DB db;

  CryptoRepository({@required this.webClient, @required this.db});

  Future loadBalance(coin) async {
    try {
      return await _getBalance(coin);
    } catch (e) {
      return Future.error(e.message);
    }
  }

  Future<int> _getBalance(coin, {balance = 0, next = 20}) async {
    final addresses = coin.generateAddresses(next: next);

    if (addresses.isEmpty) throw Exception('There aren\'t address');

    try {
      final balanceStream = _streamBalance(next, coin.name, addresses);
      final info = await _calcBalance(balanceStream);
      balance += info.balance;

      if (info.checkMore) return _getBalance(coin, balance: balance);
    } on SocketException catch (e) {
      Future.delayed(Duration(seconds: 10), () => loadBalance(coin));
      throw Exception(e.osError.message);
    } catch (e) {
      throw Exception(e.message);
    }

    return balance;
  }

  Stream<Balance> _streamBalance(int next, String name, Map addresses) async* {
    final to = addresses.length;
    final from = to - next;
    for (int i = from; i < to; i++) {
      final result =
          await webClient.getBalanceByAddress(name, addresses[i].address);
      /*
      * todo save db
      * */
//      print(result.balance);
//      print(result.address);
//      print(addresses[i].privateKey);
      /*
      *
      * */
      yield result;
    }
  }

  Future<CalcBalanceArgs> _calcBalance(Stream<Balance> stream) async {
    int balance = 0;
    bool checkMore = false;

    await for (var info in stream) {
      balance += info.balance;
      if (info.txCount > 0) checkMore = true;
    }

    return CalcBalanceArgs(balance, checkMore);
  }

  loadAddresses() {
    return [];
  }
}

class CalcBalanceArgs {
  final int balance;
  final bool checkMore;

  const CalcBalanceArgs(this.balance, this.checkMore);
}
