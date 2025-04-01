class PaymentTransaction {
  final String id;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String status;
  final String cryptoType;
  final double cryptoAmount;
  final String walletId;

  PaymentTransaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.status,
    required this.cryptoType,
    required this.cryptoAmount,
    required this.walletId,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
      cryptoType: json['cryptoType'] as String,
      cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
      walletId: json['walletId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'cryptoType': cryptoType,
      'cryptoAmount': cryptoAmount,
      'walletId': walletId,
    };
  }

  Map<String, dynamic> toNdefFormat() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'cryptoType': cryptoType,
      'cryptoAmount': cryptoAmount,
      'walletId': walletId,
    };
  }
}
