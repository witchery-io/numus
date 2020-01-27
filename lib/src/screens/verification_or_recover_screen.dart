import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationOrRecoverScreen extends StatefulWidget {
  @override
  _VerificationOrRecoverScreenState createState() =>
      _VerificationOrRecoverScreenState();
}

class _VerificationOrRecoverScreenState
    extends State<VerificationOrRecoverScreen> {
  List<String> _listWords;
  bool _isShowWords = false;
  bool _isEnableVerifiedBtn = false;
  List<int> _verificationKeys = const [0, 4, 8];

  @override
  Widget build(BuildContext context) {
    final String mnemonic = ModalRoute.of(context).settings.arguments;
    final bool isRecover = mnemonic == null;
    final listMnemonicWords = mnemonic.split(' ');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(isRecover ? 'Recover' : 'Verification',
                    style: TextStyle(fontSize: 24.0)),
                SizedBox(height: 12.0),
                isRecover
                    ? MnemonicVerificationTextField(
                        helperText:
                            '* Please type mnemonic (12 words) in your note for recover.',
                        labelText: 'Recover words',
                        onChanged: (String typedWords) {
//                          print('Recover');
//                          print(typedWords); // String
//                          print(mnemonic); // null
                        })
                    : MnemonicVerificationTextField(
                        helperText:
                            '* Please type 1, 5, 9 words in your note for verification.',
                        labelText: 'Verification words',
                        onChanged: (String typedWords) {
                          /// Verification Logic
                          final listTrimTypeWords =
                              typedWords.trim().split(' ');
                          final listTypeWords = typedWords.split(' ');

                          setState(() {
                            _isShowWords = typedWords.length != 0;

                            /// check available and update in list
                            _listWords =
                                listTypeWords.length > _verificationKeys.length
                                    ? _listWords
                                    : listTypeWords;

                            /// enable confirmed btn when words count will be 3
                            _isEnableVerifiedBtn = listTrimTypeWords.length ==
                                    _verificationKeys.length &&
                                listTypeWords.length ==
                                    _verificationKeys.length;
                          });
                        }),
                SizedBox(height: 12.0),
                Wrap(
                    spacing: 8.0,
                    children: _isShowWords
                        ? _listWords.asMap().entries.map((entry) {
                            return mnemonic == null
                                ? CustomChip(
                                    index: (entry.key + 1), title: entry.value)

                                /// case insurance verification key list undefined error
                                : entry.key < _verificationKeys.length
                                    ? CustomChip(
                                        index:
                                            (_verificationKeys[entry.key] + 1),
                                        title: entry.value)
                                    : SizedBox.shrink();
                          }).toList()
                        : []),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomButton(
                        child: Text('Confirmed'),
                        onPressed: _isEnableVerifiedBtn ? _onVerified : null,
                      )
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onVerified() {}
}
