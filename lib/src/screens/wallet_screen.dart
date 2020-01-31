import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  final mnemonic;

  WalletScreen({@required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: ListBody(children: <Widget>[
          Text('Mnemonic', style: TextStyle(fontSize: 24.0)),
          Text('$mnemonic'),
        ]));
  }
}
