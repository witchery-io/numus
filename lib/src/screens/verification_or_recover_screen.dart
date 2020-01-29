import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';
import 'package:bip39/bip39.dart' as bip39;

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
          child: Column(
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

              /// Input
              isRecover
                  ? MnemonicVerificationTextField(
                      helperText:
                          '* Please type mnemonic (12 words) in your note for recover.',
                      labelText: 'Recover words',
                      onChanged: (String typedWords) =>
                          _changeInput(typedWords, 12, () {
                            final isValidMnemonic = bip39.validateMnemonic(typedWords);

                            if (!isValidMnemonic) {
                              /// show error message when this is invalid
                              /// return
                            }

                            /// is valid Mnemonic
                            /// build modal and set pin
                            /// encode (mnemonic + pin) and save in local storage
                            ///
                          }))
                  : MnemonicVerificationTextField(
                      helperText:
                          '* Please type 1, 5, 9 words in your note for verification.',
                      labelText: 'Mnemonic verification',
                      onChanged: (String typedWords) =>
                          _changeInput(typedWords, 3, () {


                            /// mnemonic 0, 4, 8
                            /// type words, list words global -> 0, 1, 2
                            /// build modal and set pin
                            /// encode (mnemonic + pin) and save in local storage
                            ///
                          })),
              SizedBox(height: 12.0),

              /// Tags logic
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

              /// Apply btn
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

  _changeInput(String words, int availableWordsCount, Function apply) {
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
}

class VerificationOrRecoverArg {
  final String mnemonic;

  VerificationOrRecoverArg(this.mnemonic);
}
