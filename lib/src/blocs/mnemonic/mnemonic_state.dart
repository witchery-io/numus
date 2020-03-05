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

class MnemonicRemoved extends MnemonicState {}

class MnemonicGeneration extends MnemonicState {}

class MnemonicVerifyOrRecover extends MnemonicState {
  final mnemonic;

  const MnemonicVerifyOrRecover(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() => 'Mnemonic Verify Or Recover { mnemonic: $mnemonic }';
}

class MnemonicAccepted extends MnemonicState {
  final mnemonic;
  final dbPath;

  const MnemonicAccepted(this.mnemonic, this.dbPath);

  @override
  List<Object> get props => [mnemonic, dbPath];

  @override
  String toString() =>
      'Access accepted { mnemonic: $mnemonic, dbPath: $dbPath }';
}
