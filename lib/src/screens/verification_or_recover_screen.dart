import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

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
  final int _recoverWordsCount = 12;

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
                      onChanged: (String typedWords) {
                        /// Recover Logic
                        final listTypeWordsClean = typedWords.trim().split(' ');
                        final listTypeWordsLength =
                            typedWords.split(' ').length;

                        setState(() {
                          _isShowTags = typedWords.length != 0;

                          /// check available and update in list
                          _listWords = listTypeWordsLength > _recoverWordsCount
                              ? _listWords
                              : listTypeWordsClean;

                          /// enable confirmed btn when words count will be 12
                          _isEnableApplyBtn =
                              listTypeWordsClean.length == _recoverWordsCount &&
                                  listTypeWordsLength == _recoverWordsCount;
                        });

                        _onApply = () {
//                          if (true) {
//                            // todo :: isn't valid mnemonic
//                            print('Wrong Mnemonic');
//                            return;
//                          }
//
////                          print('Recover apply');
                        };
                      })
                  : MnemonicVerificationTextField(
                      helperText:
                          '* Please type 1, 5, 9 words in your note for verification.',
                      labelText: 'Mnemonic verification',
                      onChanged: (String typedWords) {
                        /// Verification Logic
                        final listTypeWordsClean = typedWords.trim().split(' ');
                        final listTypeWordsLength =
                            typedWords.split(' ').length;
                        final listMnemonic = widget.mnemonic.split(' ');

                        setState(() {
                          _isShowTags = typedWords.length != 0;

                          /// check available and update in list
                          _listWords =
                              listTypeWordsLength > _verificationKeys.length
                                  ? _listWords
                                  : listTypeWordsClean;

                          /// enable confirmed btn when words count will be 3
                          _isEnableApplyBtn = listTypeWordsClean.length ==
                                  _verificationKeys.length &&
                              listTypeWordsLength == _verificationKeys.length;
                        });

                        _onApply = () {
                          if (_listWords[0] != listMnemonic[0] ||
                              _listWords[1] != listMnemonic[4] ||
                              _listWords[2] != listMnemonic[8]) {
                            print('Words are wrong!');
                            return;
                          }

                          print('Navigate to Wallet');
                        };
                      }),
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
}

class VerificationOrRecoverArg {
  final String mnemonic;

  VerificationOrRecoverArg(this.mnemonic);
}
