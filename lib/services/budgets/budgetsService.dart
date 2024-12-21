import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetService {
  final String baseUrl = 'http://10.0.2.2:8000/api/budgets';

  Future<List<Map<String, dynamic>>> getBudgets() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
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
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(budget),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update budget');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Failed to delete budget');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
