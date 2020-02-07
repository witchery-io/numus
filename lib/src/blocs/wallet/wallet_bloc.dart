import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/core/crypto_repository.dart';
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
      final List c = await multiCurrency.getCurrencies;


      yield WalletLoaded(currencies: c);
    } catch (_) {}
  }
}
