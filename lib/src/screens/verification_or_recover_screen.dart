import 'package:barcode_scan/barcode_scan.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games.fair.wallet/src/blocs/mnemonic/bloc.dart';
import 'package:games.fair.wallet/src/screens/screens.dart';
import 'package:games.fair.wallet/src/utils/encrypt_helper.dart';
import 'package:games.fair.wallet/src/utils/utils.dart';
import 'package:games.fair.wallet/src/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerificationOrRecoverScreen extends StatefulWidget {
  final String mnemonic;

  const VerificationOrRecoverScreen(this.mnemonic);

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
                      style: titleTextStyle),
                  Text('* For split up words use space', style: infoTextStyle)
                ],
              ),
              SizedBox(height: 12.0),
              isRecover
                  ? MnemonicVerificationTextField(
                      helperText:
                          '* Please type mnemonic (12 words) in your note for recover',
                      labelText: 'Recover words',
                      onChanged: (String typedWords) {
                        _changeTextField(typedWords, 12, () {
                          final isValidMnemonic =
                              bip39.validateMnemonic(typedWords);
                          bool isValid = true;
                          if (!isValidMnemonic) {
                            isValid = false;
                            Message.show(context, 'Mnemonic is not correct');
                          }

                          if (!isValid) return;

                          _pinAlert(typedWords);
                        });
                      })
                  : MnemonicVerificationTextField(
                      helperText:
                          '* Please type 1, 5, 9 words in your note for verification',
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
                              Message.show(context, 'Key words is not correct');
                              isValid = false;
                              break;
                            }

                          if (!isValid) return;

                          _pinAlert(mnemonic);
                        });
                      }),
              SizedBox(height: 12.0),
              Wrap(
                  spacing: 6.0,
                  children: _isShowTags
                      ? _listWords.asMap().entries.map((entry) {
                          final index = isRecover
                              ? entry.key
                              : _verificationKeys[entry.key];
                          return CustomChip(
                              index: index + 1, title: entry.value);
                        }).toList()
                      : []),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                CustomButton(
                    child: Icon(FontAwesomeIcons.qrcode),
                    onPressed: () => _scan()),
                SizedBox(width: 12.0),
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

  _changeTextField(String words, int availableWordsCount, Function onApply) {
    final listWordsClean = words.trim().split(' ');
    final listWordsLength = words.split(' ').length;

    setState(() {
      _isShowTags = words.length != 0;

      _listWords =
          listWordsLength > availableWordsCount ? _listWords : listWordsClean;

      _isEnableApplyBtn = listWordsClean.length == availableWordsCount &&
          listWordsLength == availableWordsCount;

      _onApply = onApply;
    });
  }

  Future<void> _pinAlert(String mnemonic) async {
    FocusScope.of(context).requestFocus(FocusNode());

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext bc) {
          return PinAlertDialog(
              title: 'Set pin for your wallets security.',
              onConfirmed: (strPin) {
                final encrypt = EncryptHelper(pin: strPin);
                final encrypted = encrypt.encryptByPin(mnemonic);
                Navigator.pop(context);
                BlocProvider.of<MnemonicBloc>(context).add(AcceptMnemonic(
                    mnemonic: mnemonic, mnemonicBase64: encrypted.base64));
              });
        });
  }

  void _scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      if (barcode.length < 11) return Message.show(context, 'Wrong Qr');

      final scan = barcode.substring(0, barcode.length - 11);
      _pinAlert(scan);
    } on PlatformException catch (_) {
      return Message.show(context, 'You have platform issue');
    }
  }

  @override
  void dispose() {
    mnemonic = null;
    super.dispose();
  }
}

class VerificationOrRecoverArgs {
  final String mnemonic;

  VerificationOrRecoverArgs(this.mnemonic);
}
