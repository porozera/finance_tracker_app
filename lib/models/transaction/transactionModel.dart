class TransactionModel {
  final int userId;
  final int categoryId;
  final int amount;
  final String type;
  final String transactionDate;

  TransactionModel({
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.transactionDate,
  });

  // Factory method for parsing JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      userId: json['user_id'],
      categoryId: json['category_id'],
      amount: json['amount'],
      type: json['type'],
      transactionDate: json['transaction_date'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'transaction_date': transactionDate,
    };
  }
}
