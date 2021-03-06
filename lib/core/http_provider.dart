import 'package:games.fair.wallet/src/models/models.dart';

abstract class HttpProvider {
  Future<Balance> getBalanceByAddress(String curr, String address);

  Future<Balance> getBalance(String curr, String address);

  Future pushTransaction(String curr, String txHash);
}
