import 'package:flutter/material.dart';

class MnemonicVerificationTextField extends StatelessWidget {
  final Function onChanged;

  MnemonicVerificationTextField({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 0.0),
        ),
        hintText: 'Type the words here',
        helperText:
        '* Please type 1, 5, 9 words in your note for verification.',
        helperStyle: TextStyle(color: Colors.red),
        labelText: 'Mnemonic verification words',
        prefixIcon: Icon(Icons.vpn_key, color: Colors.red),
      ),
      onChanged: (words) => onChanged(words.trim().split(' ')),
    );
  }
}
