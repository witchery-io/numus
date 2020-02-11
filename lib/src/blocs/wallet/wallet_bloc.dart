import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/repositories/crypto_repository.dart';
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
      final curr = await multiCurrency.getCurrencies;
      yield WalletLoaded(
          currencies: curr.map((item) async {
        final address = await item.getAddress();
        Future<Balance> fb;
        if (address != null) {
          try {
            fb = repository.loadBalanceByAddress(item.name, address);
          } catch (_) {}
        }
        return Coin(name: item.name, icon: item.icon, address: address, fb: fb);
      }).toList());
    } catch (_) {
      yield WalletNotLoaded();
    }
  }
}
