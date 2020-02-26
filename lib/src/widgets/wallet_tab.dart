import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class WalletTab extends StatelessWidget {
  final List<Coin> currencies;

  const WalletTab({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.all(8.0),
          child: Text('Currencies', style: TextStyle(fontSize: 24.0))),
      Expanded(
          child: ListView.separated(
              padding: EdgeInsets.all(8.0),
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) =>
                  Currency(coin: currencies[index]),
              itemCount: currencies.length)),
    ]);
  }
}
