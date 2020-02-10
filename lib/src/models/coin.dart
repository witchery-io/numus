import 'package:flutter/cupertino.dart';

class OwnCoin {
  final IconData icon;
  final String name;
  final int balance;
  final Function transaction;

  OwnCoin(
      {@required this.icon,
      @required this.name,
      this.balance = 0,
      this.transaction});
}
