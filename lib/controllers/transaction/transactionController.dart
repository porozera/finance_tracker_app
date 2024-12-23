import 'package:flutter/material.dart';
import '../../models/transaction/transactionModel.dart';
import '../../services/transaction/transactionService.dart';


class TransactionController extends ChangeNotifier {
  final TransactionService _service = TransactionService();
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Fetch transactions
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = await _service.fetchTransactions();
    } catch (e) {
      debugPrint("Error in loadTransactions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a transaction
  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    try {
      await _service.createTransaction(transactionData);
      await loadTransactions(); // Reload data
    } catch (e) {
      debugPrint("Error in addTransaction: $e");
    }
  }

  // Update a transaction
  Future<void> updateTransaction(int id, Map<String, dynamic> transactionData) async {
    try {
      await _service.updateTransaction(id, transactionData);
      await loadTransactions(); // Reload data
    } catch (e) {
      debugPrint("Error in updateTransaction: $e");
    }
  }

  // Delete a transaction
  Future<void> removeTransaction(int id) async {
    try {
      await _service.deleteTransaction(id);
      await loadTransactions(); // Reload data
    } catch (e) {
      debugPrint("Error in removeTransaction: $e");
    }
  }
}
