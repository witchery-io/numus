import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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
      final c1 = curr.map((c) async {
        int balance = 0;
        final address = await c.getAddress();
        try {
          if (address != null) {
            Balance b = await repository.loadBalanceByAddress(c.name, address);
            balance = b.balance;
          }
        } catch (_) {}
        return OwnCoin(
            name: c.name,
            icon: c.icon,
            balance: balance ,
            transaction: c.transaction);
      });

      yield WalletLoaded(currencies: c1.toList());
    } catch (_) {
      yield WalletNotLoaded();
    }
  }
}
