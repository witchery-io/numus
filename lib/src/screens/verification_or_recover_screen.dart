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
  bool _wordsIsEmpty = true;
  List<int> _verificationKeys = const [0, 4, 8];

  @override
  Widget build(BuildContext context) {
    final String mnemonic = ModalRoute.of(context).settings.arguments;
    final bool isRecover = mnemonic == null;

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
                            '* Please type mnemonic (12 words) in your note for verification.',
                        labelText: 'Recover words',
                        onChanged: (String typedWords) =>
                            _onTyped(mnemonic, typedWords, _onRecover),
                      )
                    : MnemonicVerificationTextField(
                        helperText:
                            '* Please type 1, 5, 9 words in your note for verification.',
                        labelText: 'Verification words',
                        onChanged: (String typedWords) =>
                            _onTyped(mnemonic, typedWords, _onVerified),
                      ),
                SizedBox(height: 12.0),
                _wordsIsEmpty
                    ? SizedBox.shrink()
                    : Wrap(
                        spacing: 8.0,
                        children: _listWords.asMap().entries.map((entry) {
                          return mnemonic == null
                              ? CustomChip(
                                  index: (entry.key + 1), title: entry.value)

                              /// case insurance verification key list undefined error
                              : entry.key < _verificationKeys.length
                                  ? CustomChip(
                                      index: (_verificationKeys[entry.key] + 1),
                                      title: entry.value)
                                  : SizedBox.shrink();
                        }).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onTyped(String mnemonic, String typedWords, Function callback) {
    setState(() {
      _wordsIsEmpty = typedWords.length == 0;
      _listWords = typedWords.trim().split(' ');
    });

    final listWords = mnemonic.split(' ');
    callback(listWords, typedWords);
  }

  _onVerified(List<String> listWords, List<String> typedWords) {
    print('Verified');

//    print(mnemonic);
//    print(typedWords);
//    print(typedWords.length);
  }

  _onRecover(List<String> listWords, List<String> typedWords) {
    print('Recover');

//    print(mnemonic);
//    print(typedWords);
//    print(typedWords.length);
  }
}
