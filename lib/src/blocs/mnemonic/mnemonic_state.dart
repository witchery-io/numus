import 'package:equatable/equatable.dart';

abstract class MnemonicState extends Equatable {
  const MnemonicState();

  @override
  List<Object> get props => [];
}

class MnemonicLoading extends MnemonicState {}

class MnemonicLoaded extends MnemonicState {
  final String mnemonic;

  MnemonicLoaded(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'Mnemonic Loaded { mnemonic: $mnemonic }';
}

class MnemonicNotLoaded extends MnemonicState {}

