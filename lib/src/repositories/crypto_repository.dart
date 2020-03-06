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

    if (addresses.isEmpty) throw Exception('There isn\'t address');

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
      final address = addresses[i].address;
      final result = await webClient.getBalanceByAddress(name, address);
      final hasUsed = result.txCount == 0 ? 0 : 1;
      final info =
          Address(id: i, type: name, balance: result.balance, hasUsed: hasUsed);
      await db.insertAddress(info);
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

  Future transaction(String address, double price, coin) async {
    final balance = await coin.balance;
    final satPrice = price * 100000000;
    const double fee = 0.001;
    final feeSat = fee * 100000000;
    if (satPrice > balance) throw Exception('Insufficient balance');

    final unUsedAddressId = await db.getUnusedAddress(coin.name);
    final addressReceive = coin.getAddressByIndex(unUsedAddressId.first['id']);

    final addresses = [];
    try {
      final ids = await db.getValidAddressId(coin.name);
      for (var val in ids) {
        addresses.add(coin.getAddressByIndex(val['id']));
      }

      assert(addresses.isNotEmpty);
      final balanceStream = _streamBalanceMoreData(coin.name, addresses);
      final data = await _transactionInfo(balanceStream);

      final broadcast = await coin.transactionBuilder(
          fee: feeSat,
          price: satPrice,
          address: address,
          addressReceive: addressReceive.address,
          data: data);

      print(broadcast);
    } catch (e) {
      throw Exception(e.message);
    }
  }

  Stream<TransactionBuilderArgs> _streamBalanceMoreData(
      String name, List addresses) async* {
    for (var item in addresses) {
      final result = await webClient.getBalance(name, item.address);
      yield TransactionBuilderArgs(item.privateKey, item.address, result.txs);
    }
  }

  Future<List> _transactionInfo(Stream<TransactionBuilderArgs> stream) async {
    final info = [];
    await for (var val in stream) {
      info.add(val);
    }

    return info;
  }
}

class TransactionBuilderArgs {
  final String privateKey;
  final String address;
  final txs;

  TransactionBuilderArgs(this.privateKey, this.address, this.txs);
}

class CalcBalanceArgs {
  final int balance;
  final bool checkMore;

  const CalcBalanceArgs(this.balance, this.checkMore);
}
