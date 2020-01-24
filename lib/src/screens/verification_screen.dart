import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<String> _keyWords = [];
  List<int> _wordsKeys = [0, 4, 8];

  @override
  Widget build(BuildContext context) {
    final List<String> mnemonic = ModalRoute.of(context).settings.arguments;
    assert(mnemonic.length != null);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Verification', style: TextStyle(fontSize: 24.0)),
                SizedBox(height: 10.0),
                MnemonicVerificationTextField(
                    onChanged: (List<String> worldsList) {
                  if (worldsList.length > _wordsKeys.length) return;

                  setState(() => _keyWords = worldsList);
                }),
                SizedBox(height: 10.0),
                _keyWords.length == 0
                    ? SizedBox.shrink()
                    : Wrap(
                        spacing: 8.0,
                        children: _keyWords.asMap().entries.map((entry) {
                          final isEqual = mnemonic[_wordsKeys[entry.key]] ==
                              entry.value;
                          return Chip(
                            avatar: CircleAvatar(
                                backgroundColor: isEqual
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                child: Text('${_wordsKeys[entry.key] + 1}')),
                            label: Text('${entry.value}'),
                            backgroundColor: isEqual
                                ? Colors.green.shade300
                                : Colors.red.shade300,
                          );
                        }).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
