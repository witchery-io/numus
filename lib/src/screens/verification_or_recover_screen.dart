import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationOrRecoverScreen extends StatefulWidget {
  final String mnemonic;

  VerificationOrRecoverScreen(this.mnemonic);

  @override
  _VerificationOrRecoverScreenState createState() =>
      _VerificationOrRecoverScreenState(mnemonic, mnemonic == null);
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

  _VerificationOrRecoverScreenState(this.mnemonic, this.isRecover)
      : assert((isRecover && mnemonic == null) ||
            (!isRecover && mnemonic != null));

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
                        final listTrimTypeWords = typedWords.trim().split(' ');
                        final listTypeWords = typedWords.split(' ');

                        setState(() {
                          _isShowTags = typedWords.length != 0;

                          /// check available and update in list
                          _listWords = listTypeWords.length > _recoverWordsCount
                              ? _listWords
                              : listTypeWords;

                          /// enable confirmed btn when words count will be 3
                          _isEnableApplyBtn =
                              listTrimTypeWords.length == _recoverWordsCount &&
                                  listTypeWords.length == _recoverWordsCount;
                        });

                        _onApply = () {
                          if (true) {
                            // todo :: isn't valid mnemonic
                            print('Wrong Mnemonic');
                            return;
                          }

//                          print('Recover apply');
                        };
                      })
                  : MnemonicVerificationTextField(
                      helperText:
                          '* Please type 1, 5, 9 words in your note for verification.',
                      labelText: 'Words verification',
                      onChanged: (String typedWords) {
                        /// Verification Logic
                        final listTrimTypeWords = typedWords.trim().split(' ');
                        final listTypeWords = typedWords.split(' ');
                        final listMnemonic = widget.mnemonic.split(' ');

                        setState(() {
                          _isShowTags = typedWords.length != 0;

                          /// check available and update in list
                          _listWords =
                              listTypeWords.length > _verificationKeys.length
                                  ? _listWords
                                  : listTypeWords;

                          /// enable confirmed btn when words count will be 3
                          _isEnableApplyBtn = listTrimTypeWords.length ==
                                  _verificationKeys.length &&
                              listTypeWords.length == _verificationKeys.length;
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
                          return isRecover
                              ? CustomChip(
                                  index: (entry.key + 1), title: entry.value)

                              /// case insurance verification key list undefined error
                              : entry.key < _verificationKeys.length
                                  ? CustomChip(
                                      index: (_verificationKeys[entry.key] + 1),
                                      title: entry.value)
                                  : SizedBox.shrink();
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
