import 'package:equatable/equatable.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List currencies;

  WalletLoaded({this.currencies = const []});

  @override
  List<Object> get props => [currencies];

  @override
  String toString() => 'Wallet Loaded { currencies: $currencies }';
}

class WalletNotLoaded extends WalletState {}
