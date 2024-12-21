import '../../services/budgets/budgetsService.dart';


class BudgetController {
  final BudgetService _service = BudgetService();

  Future<List<Map<String, dynamic>>> fetchAllBudgets() async {
    try {
      return await _service.getBudgets();
    } catch (e) {
      throw Exception('Error fetching budgets: $e');
    }
  }

  Future<Map<String, dynamic>> fetchBudgetById(int id) async {
    try {
      return await _service.getBudgetById(id);
    } catch (e) {
      throw Exception('Error fetching budget by ID: $e');
    }
  }

  Future<void> addBudget(Map<String, dynamic> budget) async {
    try {
      await _service.createBudget(budget);
    } catch (e) {
      throw Exception('Error creating budget: $e');
    }
  }

  Future<void> updateBudget(int id, Map<String, dynamic> budget) async {
    try {
      await _service.updateBudget(id, budget);
    } catch (e) {
      throw Exception('Error updating budget: $e');
    }
  }

  Future<void> removeBudget(int id) async {
    try {
      await _service.deleteBudget(id);
    } catch (e) {
      throw Exception('Error deleting budget: $e');
    }
  }
}
