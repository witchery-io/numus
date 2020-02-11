import 'package:flutter/cupertino.dart';

class Coin {
  final IconData icon;
  final String name;
  final String address;
  int balance;

  Coin(
      {@required this.icon,
      @required this.name,
      @required this.address,
      this.balance = 0});
}
