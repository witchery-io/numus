import 'package:flutter/cupertino.dart';

import 'address.dart';

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

abstract class CryptoCoin {
  String get name;
  IconData icon;
  Map<int, Address> generateAddresses({@required int next});
  Future<void> transaction(String address, double price);
}