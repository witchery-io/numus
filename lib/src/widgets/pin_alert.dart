import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class PinAlertDialog extends StatelessWidget {
  final _pinController = TextEditingController();
  final String title;
  final Function _onConfirmed;

  PinAlertDialog(this.title, this._onConfirmed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('$title'),
        content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                    controller: _pinController,
                    autofocus: true,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: "Enter your PIN",
                      helperStyle: TextStyle(color: Colors.deepOrange),
                      helperText: "* Please set 6 symbole.",
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ])),
          ]),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Confirmed'),
              onPressed: () async {
                final strPin = _pinController.text;
                if (strPin.length != 6)
                  return Toast.show('Please set 6 symbol.', context,
                      duration: 2, gravity: Toast.TOP);

                _onConfirmed(convertToMd5(strPin));
                _pinController.clear();
              }),
        ]);
  }

  static convertToMd5(val) {
    return md5.convert(utf8.encode(val)).toString();
  }
}
