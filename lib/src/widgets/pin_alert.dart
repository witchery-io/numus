import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fundamental/src/blocs/mnemonic/bloc.dart';
import 'package:flutter_fundamental/src/utils/encrypt_helper.dart';
import 'package:toast/toast.dart';

class PinAlertDialog extends StatelessWidget {
  final pinController = TextEditingController();
  final String mnemonic;

  PinAlertDialog(this.mnemonic);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Set pin for your wallets security.'),
        content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                    controller: pinController,
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
              onPressed: () {
                final pin = pinController.text;
                if (pin.length != 6) {
                  Toast.show('Please set 6 symbol.', context,
                      duration: 2, gravity: Toast.TOP);
                  return;
                }

                final encrypt = EncryptHelper(pin: pin);
                if (mnemonic != null) {
                  final encrypted = encrypt.encryptByPin(mnemonic);
                  print(encrypted.base64);
                  BlocProvider.of<MnemonicBloc>(context)
                      .add(InsertMnemonic(encrypted.base64));

                  /// save in local secure storage
                } else {
                  try {
                    /// if has mnemonic in secure storage
                    /// async get is secure storage
                    ///
                    final decrypted = encrypt.decryptByPinByBase64(
                        '640H2A71ONIo5crRrTYG7u4eTEr/Rdp6R44fdSFklNKReGA1RIbm53JVJ6bFlSp8Bgd7nKbpbKUrR69Hk+wM9h2RxpXJUffqWt0lDMr2oFM=');
                    print(decrypted);
                  } catch (e) {
                    Toast.show(e.message, context,
                        duration: 2, gravity: Toast.TOP);
                  }
                }
              }),
        ]);
  }

  static convertToMd5(val) {
    return md5.convert(utf8.encode(val)).toString();
  }
}
