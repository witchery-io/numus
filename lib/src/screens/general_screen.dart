import 'package:flutter/material.dart';
import 'package:flutter_fundamental/core/core.dart';
import 'package:flutter_fundamental/src/screens/screens.dart';
import 'package:flutter_fundamental/src/widgets/widgets.dart';

class GeneralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          CustomButton(
              child: Text('Create New'),
              onPressed: () => Navigator.pushNamed(context, Router.generation)),
          CustomButton(
              child: Text('Recover'),
              onPressed: () => Navigator.pushNamed(
                  context, Router.verificationOrRecover,
                  arguments: VerificationOrRecoverArgs(null))),
        ]));
  }
}
