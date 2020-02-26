import 'package:flutter/cupertino.dart';

typedef OnTransaction = Future Function(String address, double price);

class Coin {
  final IconData icon;
  final String name;
  final Future futureBalance;

  const Coin({
    @required this.icon,
    @required this.name,
    @required this.futureBalance,
  });
}
