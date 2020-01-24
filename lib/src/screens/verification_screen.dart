import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final List<String> args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Center(child: Text('Verification Screen')),
      ),
    );
  }
}
