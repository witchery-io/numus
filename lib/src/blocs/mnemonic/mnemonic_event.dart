import 'package:equatable/equatable.dart';

abstract class MnemonicEvent extends Equatable {
  const MnemonicEvent();

  @override
  List<Object> get props => [];
}

class LoadMnemonic extends MnemonicEvent {}

class RemoveMnemonic extends MnemonicEvent {}
