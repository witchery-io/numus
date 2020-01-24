import 'package:flutter/material.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class VerificationScreen extends StatelessWidget {
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
                SizedBox(height: 20.0),
                SubVerification(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubVerification extends StatelessWidget {
  final _words = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 0.0),
            ),
            hintText: 'Type key words',
            helperText:
            '* Please type 1, 5, 12 words in your note for verification.',
            helperStyle: TextStyle(color: Colors.red),
            labelText: 'Mnemonic verification words',
            prefixIcon: Icon(Icons.vpn_key, color: Colors.red),
          ),
          onChanged: (text) {
            print("First text field: $text");
          },
          controller: _words,
        ),
        CustomButton(
          child: Text('Confimed'),
          onPressed: () {},
        ),
      ],
    );
  }
}
