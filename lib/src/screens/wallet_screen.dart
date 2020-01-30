import 'package:flutter/material.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

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
          CustomButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Router.initial, (_) => false);
              }),
        ]));
  }
}
