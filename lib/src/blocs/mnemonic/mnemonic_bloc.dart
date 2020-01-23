import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './bloc.dart';

class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  final FlutterSecureStorage secureStorage;

  MnemonicBloc({@required this.secureStorage});

  @override
  MnemonicState get initialState => MnemonicLoading();

  @override
  Stream<MnemonicState> mapEventToState(
    MnemonicEvent event,
  ) async* {
    if (event is LoadMnemonic) {
      yield* _loadMnemonicToState();
    }
  }

  Stream<MnemonicState> _loadMnemonicToState() async* {
    try {
      final mnemonic = await this.secureStorage.read(key: 'mnemonic');

      yield MnemonicLoaded(mnemonic);
    } catch (_) {
      yield MnemonicNotLoaded();
    }
  }
}
