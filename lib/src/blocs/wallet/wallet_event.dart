import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class LoadWallet extends WalletEvent {}

class RemoveWallet extends WalletEvent {}

class NewWallet extends WalletEvent {}
