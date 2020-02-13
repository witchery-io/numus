import 'package:flutter/material.dart';

class MnemonicVerificationTextField extends StatelessWidget {
  final Function onChanged;
  final String hintText;
  final String helperText;
  final String labelText;
  final wordsController = TextEditingController();

  MnemonicVerificationTextField(
      {@required this.onChanged,
      this.hintText,
      this.helperText,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
        autofocus: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide()),
          hintText: hintText,
          helperText: helperText,
          helperStyle: TextStyle(color: Colors.deepOrange),
          labelText: labelText,
          prefixIcon: Icon(Icons.lock_outline, color: Colors.deepOrange),
        ),
        onChanged: (words) => onChanged(words));
  }
}
