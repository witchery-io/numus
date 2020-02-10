import 'package:flutter/cupertino.dart';

class Coin {
  final IconData icon;
  final String name;
  final String publicKey;
  final String privateKey;
  final Future address;
  final Function transaction;

  Coin(
      {@required this.name,
      @required this.publicKey,
      @required this.privateKey,
      this.icon,
      this.address,
      this.transaction});

  static Coin fromEntity(entity) {
    return Coin(
        icon: entity.icon,
        name: entity.name,
        publicKey: entity.getPublicKey(),
        privateKey: entity.getPrivateKey(),
        address: entity.getAddress(),
        transaction: entity.transaction);
  }
}
