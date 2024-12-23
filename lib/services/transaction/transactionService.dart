import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../models/transaction/transactionModel.dart';


class TransactionService {
  final String baseUrl = "http://10.0.2.2:8000/api/transactions";

  // Fetch all transactions
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load transactions");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> getTransactionById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch budget by ID');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create a new transaction
  Future<void> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transactionData),
      );

      if (response.statusCode == 201) {
        // Transaction created successfully
        debugPrint('Transaction created successfully!');
      } else {
        // Handle specific error codes
        if (response.statusCode == 400) {
          // Bad request, likely validation error
          final errorJson = jsonDecode(response.body);
          final errorMessage = errorJson['message'] ?? 'Invalid transaction data';
          throw Exception('Validation error: $errorMessage');
        } else if (response.statusCode == 500) {
          // Server error
          throw Exception('Server error: ${response.body}');
        } else {
          // Other errors
          throw Exception('Failed to create transaction: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Exception: $e');
      rethrow; // Rethrow the exception for higher-level handling
    }
  }

  // Update an existing transaction
  Future<void> updateTransaction(int id, Map<String, dynamic> transactionData) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transactionData),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to update transaction");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode != 200) {
        throw Exception("Failed to delete transaction");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
