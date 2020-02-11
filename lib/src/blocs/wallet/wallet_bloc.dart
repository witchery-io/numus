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
      final c = curr.map((c) async =>
          Coin(name: c.name, icon: c.icon, address: await c.getAddress()));

      final c2 = c.map((futureCoin) async {
        final coin = await futureCoin;
        if (coin.address != null) {
          try {
            final Balance b =
                await repository.loadBalanceByAddress(coin.name, coin.address);
            coin.balance = b.balance;
          } catch (_) {}
        }

        return coin;
      });

      yield WalletLoaded(currencies: c2.toList());
    } catch (_) {
      yield WalletNotLoaded();
    }
  }
}
