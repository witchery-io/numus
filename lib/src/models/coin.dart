import 'package:flutter/cupertino.dart';

typedef OnTransaction = Future Function(
    String address, double price, Coin coin);
typedef OnGetAddressItem = Function(int index);
typedef OnAddressList = Future Function();

class Coin {
  final IconData icon;
  final String name;
  final Future balance;
  final OnGetAddressItem getAddressByIndex;
  final OnAddressList addressList;
  final OnTransaction transaction;
  final transactionBuilder;

  const Coin(
      {@required this.icon,
      @required this.name,
      @required this.balance,
      @required this.getAddressByIndex,
      @required this.addressList,
      @required this.transaction,
      @required this.transactionBuilder});
}
