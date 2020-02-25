import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundamental/src/models/models.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_fundamental/src/utils/utils.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

final TextStyle minorStyle = TextStyle(fontSize: 12.0, color: Colors.white);

class Currency extends StatelessWidget {
  final Coin coin;
  static final GlobalKey<FormState> _sendFormKey = GlobalKey<FormState>();

  const Currency({this.coin});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        leading: Icon(coin.icon),
        title: Text('${coin.name.toUpperCase()}'),
        subtitle: FutureBuilder(
          future: coin.futureBalance,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data}');
            }

            return _loading();
          },
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        CustomButton(child: Text('Send'), onPressed: () => print('Send')),
        CustomButton(child: Text('Receive'), onPressed: () => print('Receive')),
        CustomButton(
            child: Text('Transactions'),
            onPressed: () => print('Transactions')),
      ])
    ]);
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
                      /// todo
//                      try {
//                        Message.show(context, 'Your request is checking');
//                        FocusScope.of(context).requestFocus(FocusNode());
//                        Currency._sendFormKey.currentState.save();
//                        await coin.transaction(_address, double.parse(_price));
//                        Message.show(context, 'Your request has accepted');
//                        Navigator.pop(context);
//                      } catch (e) {
//                        Message.show(context, e.message);
//                      }
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
              GestureDetector(
                onTap: () {
                  Message.show(context, 'Copied');
                  Clipboard.setData(new ClipboardData(text: val));
                },
                child: QrImage(
                    data: val,
                    size: 250.0,
                    foregroundColor: Colors.grey.shade300),
              ),
              Text(val, style: minorStyle)
            ],
          );
        });
  }

  Widget _loading() {
    return Text('Data synchronization...', style: loadingStyle);
  }
}
