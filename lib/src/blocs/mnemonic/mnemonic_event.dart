import 'package:equatable/equatable.dart';

abstract class MnemonicEvent extends Equatable {
  const MnemonicEvent();

  @override
  List<Object> get props => [];
}

class LoadMnemonic extends MnemonicEvent {}

class InsertMnemonic extends MnemonicEvent {
  final mnemonic;

  const InsertMnemonic(this.mnemonic);

  @override
  List<Object> get props => [mnemonic];
}

class UpdateMnemonic extends MnemonicEvent {}

class DeleteMnemonic extends MnemonicEvent {}
