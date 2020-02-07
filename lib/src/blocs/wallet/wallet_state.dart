import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List currencies;

  WalletLoaded({@required this.currencies});
}

class WalletNotLoaded extends WalletState {}
