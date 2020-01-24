import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationScreen extends StatelessWidget {
  final _words = TextEditingController();

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
                    onChanged: (val) => _words.text = val),
                SizedBox(height: 10.0),
                CustomButton(
                  child: Text('Confimed'),
                  onPressed: () {
                    final words = _words.text.trim().split(' ');
                    if (words.length == 0) {
                      print('Empty Words');
                    } else if (words.length != 3 ||
                        words[0] != mnemonic[0] ||
                        words[1] != mnemonic[4] ||
                        words[2] != mnemonic[8]) {
                      print('Sorry you have typed wrong words.');
                    }

                    // change state to accepted mnemonic
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
