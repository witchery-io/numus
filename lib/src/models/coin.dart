import 'package:flutter/cupertino.dart';

typedef OnTransaction = Future Function(String address, double price);

class Coin {
  final IconData icon;
  final String name;
  final balance; // Future
  final address; // List
  final OnTransaction transaction;

  const Coin(
      {@required this.icon,
      @required this.name,
      @required this.balance,
      @required this.address,
      @required this.transaction});
}
