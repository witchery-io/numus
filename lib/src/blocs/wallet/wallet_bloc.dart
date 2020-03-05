import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/providers/providers.dart';
import 'package:flutter_fundamental/src/repositories/crypto_repository.dart';
import 'package:multi_currency/multi_currency.dart';
import 'package:sqflite/sqflite.dart';

import './bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final MultiCurrency multiCurrency;
  final CryptoRepository repository;

  WalletBloc({@required this.multiCurrency, @required this.repository});

  @override
  WalletState get initialState => WalletLoading();

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is LoadWallet) {
      yield* _loadWalletToState();
    }
  }

  Stream<WalletState> _loadWalletToState() async* {
    final path = await getDatabasesPath();
    print('--1---------------------------------------------------------------');
    final db = DB(path);
    print(await db.delete());
//    await db.close();
    final addresses = await db.addresses();

    print(addresses);
    
   await db.insertAddress(Address(
        id: 1,
        address: 'mgpWpWc4dg5VaFqFqn2QDg5oBLCyh2oCXU',
        settings: 'settings - 1'));
     await db.insertAddress(Address(
        id: 2,
        address: 'n2yAmihxeJbd1hRrsxhEpegj3WU65JFMgG',
        settings: 'settings - 2'));
    await db.insertAddress(Address(
        id: 3,
        address: 'mzB6jW7qYaySQnxLEdpu6ybFM3uH9y5MFf',
        settings: 'settings - 3'));


    print(addresses);

    print('--2---------------------------------------------------------------');

    try {
      final List currencies = await multiCurrency.getCurrencies;
      final c = currencies.map((coin) {
        return Coin(
            name: coin.name,
            icon: coin.icon,
            balance: repository.loadBalance(coin),
            address: repository.loadAddresses(),
            transaction: coin.transaction);
      });

      yield WalletLoaded(currencies: c.toList());
    } catch (_) {
      yield WalletNotLoaded();
    }
  }
}
