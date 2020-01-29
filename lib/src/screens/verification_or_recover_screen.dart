import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:toast/toast.dart';

class VerificationOrRecoverScreen extends StatefulWidget {
  final String mnemonic;

  VerificationOrRecoverScreen(this.mnemonic);

  @override
  _VerificationOrRecoverScreenState createState() =>
      _VerificationOrRecoverScreenState(
          mnemonic: mnemonic, isRecover: mnemonic == null);
}

class _VerificationOrRecoverScreenState
    extends State<VerificationOrRecoverScreen> {
  String mnemonic;
  bool isRecover;
  List<String> _listWords;
  bool _isShowTags = false;
  List<int> _verificationKeys = const [0, 4, 8];
  Function _onApply;
  bool _isEnableApplyBtn = false;

  _VerificationOrRecoverScreenState(
      {@required this.mnemonic, @required this.isRecover});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: ListBody(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(isRecover ? 'Recover' : 'Verification',
                      style: TextStyle(fontSize: 24.0)),
                  Text('* For split up words use space',
                      style: TextStyle(color: Colors.deepOrange))
                ],
              ),
              SizedBox(height: 12.0),
              isRecover
                  ? MnemonicVerificationTextField(
                      helperText:
                          '* Please type mnemonic (12 words) in your note for recover.',
                      labelText: 'Recover words',
                      onChanged: (String typedWords) {
                        _changeTextField(typedWords, 12, () {
                          final isValidMnemonic =
                              bip39.validateMnemonic(typedWords);
                          bool isValid = true;
                          if (!isValidMnemonic) {
                            isValid = false;
                            Toast.show('Mnemonic is not correct.', context,
                                duration: 2, gravity: Toast.TOP);
                          }

                          if (!isValid) return;

                          _pinAlert(typedWords);
                        });
                      })
                  : MnemonicVerificationTextField(
                      helperText:
                          '* Please type 1, 5, 9 words in your note for verification.',
                      labelText: 'Mnemonic verification',
                      onChanged: (String typedWords) {
                        _changeTextField(typedWords, 3, () {
                          assert(mnemonic.length != 0);
                          final mnemonicWordsList = mnemonic.split(' ');
                          assert(mnemonicWordsList.length == 12);
                          bool isValid = true;

                          for (int i = 0; i < 3; i++)
                            if (mnemonicWordsList[_verificationKeys[i]] !=
                                _listWords[i]) {
                              Toast.show('Key words is not correct.', context,
                                  duration: 2, gravity: Toast.TOP);
                              isValid = false;
                              break;
                            }

                          if (!isValid) return;

                          _pinAlert(mnemonic);
                        });
                      }),
              SizedBox(height: 12.0),
              Wrap(
                  spacing: 8.0,
                  children: _isShowTags
                      ? _listWords.asMap().entries.map((entry) {
                          return CustomChip(
                              index: isRecover
                                  ? (entry.key + 1)
                                  : (_verificationKeys[entry.key] + 1),
                              title: entry.value);
                        }).toList()
                      : []),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                CustomButton(
                    child: Text('Apply'),
                    onPressed: _isEnableApplyBtn ? _onApply : null),
              ])
            ],
          ),
        ),
      ),
    );
  }

  _changeTextField(String words, int availableWordsCount, Function apply) {
    final listWordsClean = words.trim().split(' ');
    final listWordsLength = words.split(' ').length;

    setState(() {
      _isShowTags = words.length != 0;

      _listWords =
          listWordsLength > availableWordsCount ? _listWords : listWordsClean;

      _isEnableApplyBtn = listWordsClean.length == availableWordsCount &&
          listWordsLength == availableWordsCount;

      _onApply = apply;
    });
  }

  Future<void> _pinAlert(String mnemonic) async {
    FocusScope.of(context).requestFocus(FocusNode());

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PinAlertDialog(mnemonic);
      },
    );
  }

  @override
  void dispose() {
    mnemonic = null;
    super.dispose();
  }
}

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

                final md5Pin = convertToMd5(pin);

                /// todo :: (!=)
                if (mnemonic == null) {
                  final key = encrypt.Key.fromUtf8(md5Pin);
                  final iv = encrypt.IV.fromLength(16);
                  final enc = encrypt.Encrypter(encrypt.AES(key));
                  final encrypted = enc.encrypt(mnemonic, iv: iv);

                  print(encrypted);
                  print(encrypted.base64);

                  // pin 111111
                  // 640H2A71ONIo5crRrTYG7u4eTEr/Rdp6R44fdSFklNKReGA1RIbm53JVJ6bFlSp8Bgd7nKbpbKUrR69Hk+wM9h2RxpXJUffqWt0lDMr2oFM=
                  // save in local secure storage

                } else {
                  final key = encrypt.Key.fromUtf8(md5Pin);
                  final iv = encrypt.IV.fromLength(16);
                  final enc = encrypt.Encrypter(encrypt.AES(key));

                  /// get in local storage

                  try {
                    final decrypted = enc.decrypt64('640H2A71ONIo5crRrTYG7u4eTEr/Rdp6R44fdSFklNKReGA1RIbm53JVJ6bFlSp8Bgd7nKbpbKUrR69Hk+wM9h2RxpXJUffqWt0lDMr2oFM=', iv: iv);
                    print(decrypted);
                  } catch (e) {
                    Toast.show(e.message, context, duration: 2, gravity: Toast.TOP);
                  }
                }
              }),
        ]);
  }

  static convertToMd5(val) {
    return md5.convert(utf8.encode(val)).toString();
  }
}

class VerificationOrRecoverArg {
  final String mnemonic;

  VerificationOrRecoverArg(this.mnemonic);
}
