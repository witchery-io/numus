import 'package:flutter/cupertino.dart';
import 'package:flutter_fundamental/src/models/models.dart';

class Coin {
  final IconData icon;
  final String name;
  final String address;
  Future<Balance> fb;

  Coin(
      {@required this.icon,
      @required this.name,
      @required this.address,
      this.fb});
}
