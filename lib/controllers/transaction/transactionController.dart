import 'package:flutter/material.dart';
import '../../models/transaction/transactionModel.dart';
import '../../services/transaction/transactionService.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _transactionService.createTransaction(transaction);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
