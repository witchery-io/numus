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
  bool _isShowTags = false;
  bool _isEnableVerifiedBtn = false;
  List<int> _verificationKeys = const [0, 4, 8];

  @override
  Widget build(BuildContext context) {
    final String mnemonic = ModalRoute.of(context).settings.arguments;
    final bool isRecover = mnemonic == null;

    // todo :: assets

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(isRecover ? 'Recover' : 'Verification',
                        style: TextStyle(fontSize: 24.0)),
                    Text('* For split up words use space',
                        style: TextStyle(color: Colors.red))
                  ],
                ),
                SizedBox(height: 12.0),
                isRecover
                    ? MnemonicVerificationTextField(
                        helperText:
                            '* Please type mnemonic (12 words) in your note for recover.',
                        labelText: 'Recover words',
                        onChanged: (String typedWords) {})
                    : MnemonicVerificationTextField(
                        helperText:
                            '* Please type 1, 5, 9 words in your note for verification.',
                        labelText: 'Words verification',
                        onChanged: (String typedWords) {
                          /// Verification Logic
                          final listTrimTypeWords =
                              typedWords.trim().split(' ');
                          final listTypeWords = typedWords.split(' ');

                          setState(() {
                            _isShowTags = typedWords.length != 0;

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
                    children: _isShowTags
                        ? _listWords.asMap().entries.map((entry) {
                            /// todo ::
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
                        child: Text('Apply'),
                        onPressed: _isEnableVerifiedBtn
                            ? isRecover ? _onRecover : _onVerified
                            : null,
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onVerified() {}

  _onRecover() {}
}
