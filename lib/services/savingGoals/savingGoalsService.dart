import 'dart:convert';
import 'package:finance_tracker_app/models/savingGoals/savingGoalModel.dart';
import 'package:http/http.dart' as http;

class GoalService {
  final String baseUrl = 'http://10.0.2.2:8000/api/saving-goals';

  // Fetch all goals
  Future<List<GoalModel>> fetchGoals() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => GoalModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load goals');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGoalsById(int id) async {
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

  // Create a new goal
  Future<void> createGoal(Map<String, dynamic> goalData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(goalData),
      );
      if (response.statusCode != 201) {
        throw Exception("Failed to create goal");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing goal
  Future<void> updateGoal(int id, Map<String, dynamic> goalData) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(goalData),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to update goal");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete a goal
  Future<void> deleteGoal(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode != 200) {
        throw Exception("Failed to delete goal");
      }
    } catch (e) {
      rethrow;
    }
  }
}
