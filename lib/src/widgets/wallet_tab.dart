import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class WalletTab extends StatelessWidget {
  final List<Future<Coin>> currencies;

  WalletTab({@required this.currencies});

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
                  _Currency(item: currencies[index]),
              itemCount: currencies.length)),
    ]);
  }
}

class _Currency extends StatelessWidget {
  final Future<Coin> item;

  _Currency({this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Coin coin = snapshot.data;
          return ListTile(
              leading: Icon(coin.icon),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${coin.name.toUpperCase()}'),
                    FutureBuilder(
                      future: coin.fb,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('${snapshot.error}', style: loadingStyle);
                        }

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return _centerLoading();
                          case ConnectionState.none:
                            return Text('No data', style: loadingStyle);
                          case ConnectionState.done:
                            final Balance data = snapshot.data;
                            return Text('${data.balance / 100000000}');
                          default:
                            return null; // unknown
                        }
                      },
                    ),
                  ]),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomButton(child: Text('Send'), onPressed: () {}),
                  CustomButton(child: Text('Receive'), onPressed: () {}),
                  CustomButton(child: Text('Transactions'), onPressed: () {}),
                ],
              ));
        }
        return _centerLoading();
      },
      future: item,
    );
  }

  Widget _centerLoading() {
    return Center(child: Text('Loading...', style: loadingStyle));
  }
}
