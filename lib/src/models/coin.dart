import 'package:flutter/cupertino.dart';

typedef OnTransaction = Future Function(String address, double price);
//typedef OnAddress = Future Function();

class Coin {
  final IconData icon;
  final String name;
  final Future balance;
  final List address;
  final addressList;
  final OnTransaction transaction;

  const Coin(
      {@required this.icon,
      @required this.name,
      @required this.balance,
      @required this.address,
      @required this.addressList,
      @required this.transaction});
}
