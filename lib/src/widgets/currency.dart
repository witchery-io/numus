import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:games.fair.wallet/src/models/models.dart';
import 'package:games.fair.wallet/src/screens/screens.dart';
import 'package:games.fair.wallet/src/utils/utils.dart';
import 'package:games.fair.wallet/src/widgets/widgets.dart';
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
        enabled: coin.isActive,
        leading: Icon(coin.icon),
        title: Text('${coin.name.toUpperCase()}'),
        subtitle: FutureBuilder(
          future: coin.balance,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'No data',
                style: TextStyle(fontSize: 10.0),
              );
            }

            if (snapshot.hasData) {
              return Text('${snapshot.data / 100000000}');
            }

            return _loading();
          },
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        CustomButton(
            child: Text('Send'),
            onPressed: coin.isActive ? () => _send(context, coin) : null),
        CustomButton(
            child: Text('Receive'),
            onPressed: coin.isActive ? () => _showAddresses(context) : null),
        CustomButton(child: Text('Transactions'), onPressed: null),
      ]),
    ]);
  }

  _showAddresses(BuildContext context) async {
    final List addresses = await coin.addressList();

    if (addresses.isEmpty) return Message.show(context, 'There isn\'t address');

    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Column(
                  children: addresses.map((value) {
            return ListTile(
                leading: Icon(coin.icon),
                title: Text(value.address, style: loadingStyle),
                trailing: GestureDetector(
                    onTap: () => _showQr(context, 'Qr code', value.address),
                    child: Icon(FontAwesomeIcons.qrcode)));
          }).toList()));
        });
  }

  void _send(BuildContext context, Coin coin) async {
    String _address, _amount;
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
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText:
                            'Enter only ${coin.name.toUpperCase()} address',
                        icon: Icon(FontAwesomeIcons.qrcode),
                        fillColor: Colors.white),
                    validator: (String value) {
                      if (value.isEmpty) return 'Please enter address';

                      return null;
                    },
                    onSaved: (value) => _address = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Amount',
                        icon: Icon(FontAwesomeIcons.coins),
                        fillColor: Colors.white),
                    validator: (String value) {
                      if (value.isEmpty) return 'Please enter amount';

                      final n = double.tryParse(value);
                      if (n == null) return 'Invalid: $value';

                      return null;
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSaved: (value) => _amount = value,
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context);
                        Message.show(context, 'Your request is checking');
                        Currency._sendFormKey.currentState.save();
                        await coin.transaction(
                            _address, double.parse(_amount), coin);
                        Message.show(context, 'Your request has accepted');
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
        backgroundColor: Colors.black87,
        builder: (BuildContext context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$title', style: titleTextStyle),
                GestureDetector(
                  onTap: () {
                    Message.show(context, 'Copied');
                    Clipboard.setData(ClipboardData(text: val));
                  },
                  child: QrImage(
                      data: val,
                      size: 250.0,
                      foregroundColor: Colors.grey.shade300),
                ),
                Text(val, style: minorStyle)
              ]);
        });
  }

  Widget _loading() {
    return Text('Data synchronization...', style: loadingStyle);
  }
}
