import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/budgets/budgetsModel.dart';

class BudgetService {
  final String baseUrl = 'http://10.0.2.2:8000/api/budgets';

  Future<List<Budgets>> getBudgets() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Budgets.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch budgets');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getBudgetById(int id) async {
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

  Future<void> createBudget(Map<String, dynamic> budget) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(budget),
      );
      if (response.statusCode != 201) {
        print('Failed to create budget. Response: ${response.body}');
        throw Exception('Failed to create budget');
      }
    } catch (e) {
      print('Error during createBudget: $e');
      throw Exception('Error: $e');
    }
  }

  Future<void> updateBudget(int id, Map<String, dynamic> budget) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'), // Ensure this is the correct endpoint
        headers: {
          'Content-Type': 'application/json',
          // Include authentication headers if required, e.g., 'Authorization': 'Bearer YOUR_TOKEN'
        },
        body: json.encode(budget),
      );

      if (response.statusCode == 200) {
        print('Budget updated successfully');
      } else {
        print('Failed to update budget. Response: ${response.body}');
        throw Exception('Failed to update budget');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error updating budget');
    }
  }



  Future<void> deleteBudget(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to delete budget. Status code: ${response.statusCode}');
    }
  }
}
