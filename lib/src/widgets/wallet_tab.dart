import 'package:flutter/material.dart';
import 'package:games.fair.wallet/src/models/models.dart';
import 'package:games.fair.wallet/src/widgets/widgets.dart';

class WalletTab extends StatelessWidget {
  final List<Coin> currencies;

  const WalletTab({@required this.currencies});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
