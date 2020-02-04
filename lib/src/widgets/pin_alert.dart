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

                final encrypt = EncryptHelper(pin: strPin);

                if (args.isCheck) {
                  try {
                    final mnemonic =
                        encrypt.decryptByPinByBase64(args.mnemonic);
                    BlocProvider.of<MnemonicBloc>(context).add(AcceptMnemonic(
                        mnemonic: mnemonic, mnemonicBase64: null));
                  } catch (e) {
                    Toast.show(e.message, context,
                        duration: 2, gravity: Toast.TOP);
                  }
                } else {
                  final encrypted = encrypt.encryptByPin(args.mnemonic);
                  BlocProvider.of<MnemonicBloc>(context).add(AcceptMnemonic(
                      mnemonic: args.mnemonic,
                      mnemonicBase64: encrypted.base64));
                }
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
  bool isCheck;

  PinAlertDialogArgs(
      {@required this.title, @required this.mnemonic, @required this.isCheck});
}
