import 'package:flutter/material.dart';
import '../../controllers/budgets/budgetsController.dart';
import '../../models/budgets/budgetsModel.dart';
import '../../services/budgets/budgetsService.dart';
import 'addBudget.dart';
import 'editBudget.dart';


class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final BudgetService _budgetService = BudgetService();
  final BudgetController _controller = BudgetController();
  List<Budgets> budgets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBudgets();
  }

  Future<void> fetchBudgets() async {
    try {
      final data = await _budgetService.getBudgets();
      setState(() {
        budgets = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching budgets: $e')),
      );
    }
  }

  void _deleteBudget(int id) async {
    try {
      print('Deleting budget with ID: $id');
      await _controller.removeBudget(id);

      // Refresh data from server
      final refreshedBudgets = await _controller.fetchAllBudgets();
      setState(() {
        budgets = refreshedBudgets;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget deleted successfully')),
      );
    } catch (e) {
      print('Error deleting budget: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete budget')),
      );
    }
  }

  void navigateToEdit(int id) {
    // Navigate to the EditBudgetScreen with the given budget ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBudgetScreen(budgetId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : budgets.isEmpty
          ? const Center(
        child: Text('No Budgets Available'),
      )
          : ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: ListTile(
              title: Text(
                'Budget by ${budget.user.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Amount: ${budget.firstAmount}'),
                  Text('Current Amount: ${budget.currentAmount}'),
                ],
              ),
              trailing: Wrap(
                spacing: 8.0, // Space between buttons
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Navigate to the EditBudgetScreen
                      navigateToEdit(budget.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Delete budget with the given ID
                      _deleteBudget(budget.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the TransactionFormScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BudgetsAddScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Budget',
      ),
    );
  }
}
