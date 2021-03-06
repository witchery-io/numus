import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:games.fair.wallet/src/models/models.dart';
import 'package:games.fair.wallet/src/repositories/crypto_repository.dart';
import 'package:multi_currency/multi_currency.dart';

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
    try {
      final List currencies = await multiCurrency.getCurrencies;
      final c = currencies.map((coin) {
        return Coin(
            name: coin.name,
            icon: coin.icon,
            isActive: coin.isActive,
            balance: repository.loadBalance(coin),
            getAddressByIndex: coin.getAddressByIndex,
            addressList: coin.addressList,
            transaction: repository.transaction,
            transactionBuilder: coin.transactionBuilder);
      });

      yield WalletLoaded(currencies: c.toList());
    } catch (_) {
      yield WalletNotLoaded();
    }
  }
}
