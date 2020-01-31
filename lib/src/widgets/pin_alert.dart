import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/screens/initial_screen.dart';
import 'package:flutter_fundamental/src/utils/encrypt_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toast/toast.dart';

class PinAlertDialog extends StatelessWidget {
  final pinController = TextEditingController();
  final PinAlertDialogArgs args;

  PinAlertDialog(this.args);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('${args.title}'),
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
                final strPin = pinController.text;
                if (strPin.length != 6) {
                  Toast.show('Please set 6 symbol.', context,
                      duration: 2, gravity: Toast.TOP);
                  return;
                }

                String mnemonic = args.mnemonic;
                final encrypt = EncryptHelper(pin: strPin);

                /*
                * VERIFICATION OR RECOVER
                * */
                if (mnemonic != null) {
                  final encrypted = encrypt.encryptByPin(mnemonic);

                  final secureStorage = FlutterSecureStorage();
                  await secureStorage.write(
                      key: 'mnemonic', value: encrypted.base64);
                } else {
                  /*
                  * EXISTING SCREEN
                  * */
                  assert(args.base64Mnemonic != null);
                  try {
                    mnemonic =
                        encrypt.decryptByPinByBase64(args.base64Mnemonic);
                  } catch (e) {
                    Toast.show(e.message, context,
                        duration: 2, gravity: Toast.TOP);
                    return;
                  }
                }

                Navigator.pushNamedAndRemoveUntil(
                    context, Router.initial, (_) => false,
                    arguments: InitialArgs(mnemonic));
              }),
        ]);
  }

  static convertToMd5(val) {
    return md5.convert(utf8.encode(val)).toString();
  }
}

class PinAlertDialogArgs {
  final title;
  final mnemonic;
  final base64Mnemonic;

  PinAlertDialogArgs(
      {@required this.title,
      @required this.mnemonic,
      @required this.base64Mnemonic});
}
