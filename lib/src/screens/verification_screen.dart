import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationScreen extends StatelessWidget {
  final _words = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> args = ModalRoute.of(context).settings.arguments;
    assert(args.length != null);

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
                        words[0] != args[0] ||
                        words[1] != args[4] ||
                        words[2] != args[8]) {
                      print('Sorry you have typed wrong.');
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
