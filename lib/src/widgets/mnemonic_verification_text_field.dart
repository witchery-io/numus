import 'package:flutter/material.dart';

class MnemonicVerificationTextField extends StatelessWidget {
  final Function onChanged;
  final wordsController = TextEditingController();

  MnemonicVerificationTextField({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide()),
        hintText: 'Type the words here',
        helperText:
            '* Please type 1, 5, 9 words in your note for verification.',
        helperStyle: TextStyle(color: Colors.deepOrange),
        labelText: 'Mnemonic verification words',
        prefixIcon: Icon(Icons.vpn_key, color: Colors.deepOrange),
      ),
      onChanged: (words) => onChanged(words.trim().split(' ')),
    );
  }
}
