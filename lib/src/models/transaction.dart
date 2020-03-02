import 'models.dart';

class Transaction {
  final List addresses;
  final String blockHash;
  final int blockHeight;
  final int confirmations;
  final int confirmed;
  final int fees;
  final String hash;
  final int lockTime;
  final int received;
  final int size;
  final int total;
  final int version;
  final List<Input> inputs;
  final List<Output> outputs;

  Transaction(
      {this.addresses,
      this.blockHash,
      this.blockHeight,
      this.confirmations,
      this.confirmed,
      this.fees,
      this.hash,
      this.lockTime,
      this.received,
      this.size,
      this.total,
      this.version,
      this.inputs,
      this.outputs});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        addresses: json['addresses'],
        blockHash: json['block_hash'],
        blockHeight: json['block_height'],
        confirmations: json['confirmations'],
        confirmed: json['confirmed'],
        fees: json['fees'],
        hash: json['hash'],
        lockTime: json['lock_time'],
        received: json['received'],
        size: json['size'],
        total: json['total'],
        version: json['version'],
        inputs: List.of(json['inputs'])
            .map((input) => Input.fromJson(input))
            .toList(),
        outputs: List.of(json['outputs'])
            .map((output) => Output.fromJson(output))
            .toList());
  }
}
