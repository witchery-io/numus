import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MnemonicEvent extends Equatable {
  const MnemonicEvent();

  @override
  List<Object> get props => [];
}

class LoadMnemonic extends MnemonicEvent {}

class RemoveMnemonic extends MnemonicEvent {}

class NewMnemonic extends MnemonicEvent {}

class VerifyOrRecoverMnemonic extends MnemonicEvent {
  final String mnemonic;

  const VerifyOrRecoverMnemonic(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'Recover Or Verify { mnemonic: $mnemonic }';
}

class AcceptMnemonic extends MnemonicEvent {
  final String mnemonic;
  final String mnemonicBase64;

  AcceptMnemonic({@required this.mnemonic, @required this.mnemonicBase64});

  @override
  List<Object> get props => [mnemonic, mnemonicBase64];

  @override
  String toString() =>
      'Accepted { mnemonic: $mnemonic, mnemonicBase64: $mnemonicBase64 }';
}
