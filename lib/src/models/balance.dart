class Balance {
  final String address;
  final int balance;
  final int finalBalance;
  final int totalReceived;
  final int totalSent;
  final int txCount;
  final int unconfirmedBalance;
  final int unconfirmedTxCount;
  final List txs;

  Balance(
      {this.address,
      this.balance,
      this.finalBalance,
      this.totalReceived,
      this.totalSent,
      this.txCount,
      this.unconfirmedBalance,
      this.unconfirmedTxCount,
      this.txs});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
        address: json['address'],
        balance: json['balance'],
        finalBalance: json['finalBalance'],
        totalReceived: json['totalReceived'],
        totalSent: json['totalSent'],
        txCount: json['txCount'],
        unconfirmedBalance: json['unconfirmedBalance'],
        unconfirmedTxCount: json['unconfirmedTxCount'],
        txs: json['txs']
    );
  }
}
