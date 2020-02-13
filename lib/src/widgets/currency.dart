import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_fundamental/src/utils/utils.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Currency extends StatelessWidget {
  final Future<Coin> item;
  static final GlobalKey<FormState> _sendFormKey = GlobalKey<FormState>();

  Currency({this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Coin coin = snapshot.data;
          return Column(children: <Widget>[
            ListTile(
                leading: Icon(coin.icon),
                title: Text('${coin.name.toUpperCase()}'),
                subtitle: FutureBuilder(
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
                    })),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomButton(
                      child: Text('Send'),
                      onPressed: () => _send(context, coin)),
                  CustomButton(
                      child: Text('Receive'),
                      onPressed: () =>
                          _showQr(context, 'Scan Qr', coin.address)),
                  CustomButton(child: Text('Transactions'), onPressed: () {}),
                ])
          ]);
        }
        return _centerLoading();
      },
      future: item,
    );
  }

  void _send(BuildContext context, Coin coin) async {
    String _address, _price;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _sendFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        hintText:
                            'Enter only ${coin.name.toUpperCase()} address'),
                    validator: (String value) {
                      if (value.isEmpty) return 'Please enter address';

                      return null;
                    },
                    onSaved: (value) => _address = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Price'),
                    validator: (String value) {
                      if (value.isEmpty) return 'Please enter price';

                      final n = double.tryParse(value);
                      if (n == null) return 'Invalid: $value';

                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _price = value,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Send'),
                  onPressed: () async {
                    if (_sendFormKey.currentState.validate()) {
                      try {
                        Currency._sendFormKey.currentState.save();
                        FocusScope.of(context).requestFocus(FocusNode());
                        Message.show(context, 'Your request is checking');
                        await coin.transaction(_address, double.parse(_price));
                        Message.show(context, 'Your request has accepted');
                        Navigator.pop(context);
                      } catch (e) {
                        Message.show(context, e.message);
                      }
                    }
                  }),
            ],
          );
        });
  }

  void _showQr(BuildContext context, String title, String val) async {
    if (val == null) return Message.show(context, 'Qr is absent');

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$title', style: titleTextStyle),
              QrImage(
                  data: val, size: 250.0, foregroundColor: Colors.grey.shade300)
            ],
          );
        });
  }

  Widget _centerLoading() {
    return Center(child: Text('Loading...', style: loadingStyle));
  }
}
