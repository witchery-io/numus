import 'package:flutter/material.dart';

class WalletTheme {
  static get theme {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        accentColor: Colors.deepPurple[600],
        buttonColor: Colors.grey[800],
        textSelectionColor: Colors.deepPurple[100],
        backgroundColor: Colors.grey[800],
        toggleableActiveColor: Colors.deepPurple[300],
        textTheme: originalTextTheme.copyWith(
            body1:
                originalBody1.copyWith(decorationColor: Colors.transparent)));
  }
}
