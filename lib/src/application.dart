import 'package:flutter/material.dart';
import 'package:flutter_fundamental/core/theme.dart';

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
      home: Scaffold(
        appBar: AppBar(title: Text('Wallet'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Application')],
          ),
        ),
      ),
    );
  }
}
