class Balance {
  final String address;
  final int balance;
  final int finalBalance;
  final int totalReceived;
  final int totalSent;
  final int txCount;
  final int unconfirmedBalance;
  final int unconfirmedTxCount;

  Balance({
    this.address,
    this.balance,
    this.finalBalance,
    this.totalReceived,
    this.totalSent,
    this.txCount,
    this.unconfirmedBalance,
    this.unconfirmedTxCount,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      address: json['address'],
      balance: json['balance'],
      finalBalance: json['final_balance'],
      totalReceived: json['total_received'],
      totalSent: json['total_sent'],
      txCount: json['tx_count'],
      unconfirmedBalance: json['unconfirmed_balance'],
      unconfirmedTxCount: json['unconfirmed_tx_count'],
    );
  }
}
