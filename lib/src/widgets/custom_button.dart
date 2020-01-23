import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;

  final Function onPressed;

  CustomButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
