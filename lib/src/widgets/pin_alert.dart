import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundamental/src/utils/encrypt_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
              onPressed: () async {
                final pin = pinController.text;
                if (pin.length != 6) {
                  Toast.show('Please set 6 symbol.', context,
                      duration: 2, gravity: Toast.TOP);
                  return;
                }

                final encrypt = EncryptHelper(pin: pin);
                final secureStorage = FlutterSecureStorage();

                if (mnemonic != null) {
                  final encrypted = encrypt.encryptByPin(mnemonic);
                  await secureStorage.write(
                      key: 'mnemonic', value: encrypted.base64);
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'verification', (_) => false,
                      arguments: mnemonic);
                } else {
                  try {
                    final mnemonicBase64 = secureStorage.read(key: 'mnemonic');
                    assert(mnemonicBase64 != null);
                    final mnemonic =
                        encrypt.decryptByPinByBase64(mnemonicBase64);
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'verification', (_) => false,
                        arguments: mnemonic);
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
