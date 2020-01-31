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
  Stream<MnemonicState> mapEventToState(MnemonicEvent event) async* {
    if (event is LoadMnemonic) {
      yield* _loadMnemonicToState();
    } else if (event is RemoveMnemonic) {
      yield* _removeMnemonicToState();
    } else if (event is NewMnemonic) {
      yield* _newMnemonicToState();
    } else if (event is VerifyOrRecoverMnemonic) {
      yield* _verifyOrRecoverMnemonicToState(event);
    } else if (event is AcceptMnemonic) {
      yield* _acceptOrRecoverMnemonicToState(event);
    }
  }

  Stream<MnemonicState> _loadMnemonicToState() async* {
    try {
      final mnemonic = await this.secureStorage.read(key: 'mnemonic');
      if (mnemonic == null) throw Exception('Mnemonic is null');

      yield MnemonicLoaded(mnemonic);
    } catch (_) {
      yield MnemonicNotLoaded();
    }
  }

  Stream<MnemonicState> _removeMnemonicToState() async* {
    await this.secureStorage.delete(key: 'mnemonic');
    yield MnemonicRemoved();
  }

  Stream<MnemonicState> _newMnemonicToState() async* {
    yield MnemonicGeneration();
  }

  Stream<MnemonicState> _verifyOrRecoverMnemonicToState(
      VerifyOrRecoverMnemonic event) async* {
    yield MnemonicVerifyOrRecover(event.mnemonic);
  }

  Stream<MnemonicState> _acceptOrRecoverMnemonicToState(
      AcceptMnemonic event) async* {
    try {
      if (event.mnemonicBase64 != null)
        await this
            .secureStorage
            .write(key: 'mnemonic', value: event.mnemonicBase64);

      yield MnemonicAccepted(event.mnemonic);
    } catch (_) {}
  }
}
