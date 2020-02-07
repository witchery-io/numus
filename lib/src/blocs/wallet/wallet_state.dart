import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List currencies;
  WalletLoaded(this.currencies);
}

class WalletNotLoaded extends WalletState {}
