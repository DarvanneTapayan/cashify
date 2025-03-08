class Transaction {
  final int id;
  final String timestamp;
  final double total;
  final String paymentMethod;

  Transaction({
    required this.id,
    required this.timestamp,
    required this.total,
    required this.paymentMethod,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int,
      timestamp: map['timestamp'] as String,
      total: map['total'] as double,
      paymentMethod: map['payment_method'] as String,
    );
  }
}