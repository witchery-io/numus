import 'package:flutter/material.dart';

class WalletTheme {
  static get theme {
    final originalTextTheme = ThemeData.dark().textTheme;
    final originalBody1 = originalTextTheme.body1;

    return ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        accentColor: Colors.white,
        buttonColor: Colors.grey[800],
        textSelectionColor: Colors.white,
        backgroundColor: Colors.grey[800],
        toggleableActiveColor: Colors.white,
        textTheme: originalTextTheme.copyWith(
            body1:
                originalBody1.copyWith(decorationColor: Colors.transparent)));
  }
}
