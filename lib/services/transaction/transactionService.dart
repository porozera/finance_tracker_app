import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../models/transaction/transactionModel.dart';


class TransactionService {
  final String baseUrl = 'https://finance-tracker-backend-zi0p.onrender.com/api/transactions';

  Future<bool> createTransaction(TransactionModel transaction) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(transaction.toJson()),
      );

      if (response.statusCode == 201) {
        return true; // Berhasil
      } else {
        // Print error and JSON response to the terminal
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to create transaction: ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception: $e'); // Print exception details
      rethrow;
    }
  }
}