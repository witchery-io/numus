import 'package:flutter/material.dart';
import 'package:flutter_fundamental/core/routes.dart';
import 'package:flutter_fundamental/core/theme.dart';
import 'package:flutter_fundamental/src/screens/initial_screen.dart';

import 'localization.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: FlutterBlocLocalizations().appTitle,
      theme: WalletTheme.theme,
      localizationsDelegates: [
        FlutterBlocLocalizationsDelegate(),
      ],
      routes: {
        Routes.home: (context) {
          return InitialScreen();
        },
      },
    );
  }
}
