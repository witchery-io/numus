import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnConfirmCallback = Function(String pin);

class PinAlertDialog extends StatefulWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String title;
  final OnConfirmCallback onConfirmed;

  PinAlertDialog({@required this.title, @required this.onConfirmed});

  @override
  _PinAlertDialogState createState() => _PinAlertDialogState();

  static convertToMd5(val) {
    return md5.convert(utf8.encode(val)).toString();
  }
}

class _PinAlertDialogState extends State<PinAlertDialog> {
  String _pin;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('${widget.title}'),
        content: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Form(
                key: PinAlertDialog._formKey,
                child: TextFormField(
                  initialValue: '',
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
                  ],
                  validator: (val) {
                    if (val.trim().isEmpty) {
                      return 'Please enter PIN.';
                    } else if (val.trim().length != 6) {
                      return 'Please enter 6 symbol';
                    }

                    return null;
                  },
                  onSaved: (value) => _pin = value,
                ),
              )),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Confirmed'),
              onPressed: () async {
                if (PinAlertDialog._formKey.currentState.validate()) {
                  PinAlertDialog._formKey.currentState.save();
                  widget.onConfirmed(PinAlertDialog.convertToMd5(_pin));
                }
              }),
        ]);
  }

}
