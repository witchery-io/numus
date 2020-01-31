import 'package:equatable/equatable.dart';

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

class AcceptMnemonic extends MnemonicEvent {}
