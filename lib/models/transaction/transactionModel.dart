import 'package:intl/intl.dart';

class TransactionModel {
  final int id;
  final int userId;
  final int budgetId;
  final int? savingGoals;
  final int categoryId;
  final double amount;
  final String type;
  final String title;
  final DateTime transactionDate;
  final Category category;

  String get transactionDateString => DateFormat('yyyy-MM-dd').format(transactionDate);

  Map<String, dynamic> toJson() {
    return {
      // ... other properties ...
      'transaction_date': transactionDateString, // Use the string representation
    };
  }

  TransactionModel({
    required this.id,
    required this.userId,
    required this.budgetId,
    required this.savingGoals,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.title,
    required this.transactionDate,
    required this.category,
  });

  // Factory method for parsing JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      budgetId: json['budget_id'],
      savingGoals: json['saving_goals'],
      categoryId: json['category_id'],
      amount: double.parse(json['amount']),
      type: json['type'],
      title: json['title'],
      transactionDate: DateTime.parse(json['transaction_date']),
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  // Factory method for parsing JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
