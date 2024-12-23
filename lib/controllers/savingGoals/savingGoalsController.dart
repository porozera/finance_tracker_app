import 'package:flutter/material.dart';
import '../../models/savingGoals/savingGoalModel.dart';
import '../../services/savingGoals/savingGoalsService.dart';

class GoalController extends ChangeNotifier {
  final GoalService _goalService = GoalService();
  List<GoalModel> _goals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch goals from API
  Future<void> fetchGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goals = await _goalService.fetchGoals();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load goals";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new goal
  Future<void> createGoal(Map<String, dynamic> goalData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _goalService.createGoal(goalData);
      await fetchGoals();  // Fetch updated list of goals
    } catch (e) {
      _errorMessage = "Failed to create goal";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing goal
  Future<void> updateGoal(int id, Map<String, dynamic> goalData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _goalService.updateGoal(id, goalData);
      await fetchGoals();  // Fetch updated list of goals
    } catch (e) {
      _errorMessage = "Failed to update goal";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a goal
  Future<void> deleteGoal(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _goalService.deleteGoal(id);
      await fetchGoals();  // Fetch updated list of goals
    } catch (e) {
      _errorMessage = "Failed to delete goal";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
