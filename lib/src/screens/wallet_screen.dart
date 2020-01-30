import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  final mnemonic;

  WalletScreen({@required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Wallet: Mnemonic: $mnemonic'));
  }
}
