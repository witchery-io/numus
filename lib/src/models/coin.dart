import 'package:flutter/cupertino.dart';

class Coin {
  final IconData icon;
  final String name;
  final String address;
  Future fb;

  Coin(
      {@required this.icon,
      @required this.name,
      @required this.address,
      this.fb});
}
