import 'package:flutter/material.dart';
import '../../controllers/budgets/budgetsController.dart';
import 'addBudget.dart';
import '../../models/budgets/budgetsModel.dart';
import '../../services/budgets/budgetsService.dart';
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

      // Refresh data dari server
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

  void navigateToAddBudget() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetsAddScreen(onBudgetAdded: fetchBudgets),
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
          ? const Center(child: CircularProgressIndicator())
          : budgets.isEmpty
          ? const Center(child: Text('No Budgets Available'))
          : ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final budget = budgets[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                'Budget by ${budget.user.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Amount: ${budget.firstAmount}'),
                  Text('Current Amount: ${budget.currentAmount}'),
                ],
              ),
              trailing: Wrap(
                spacing: 8.0,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      // Navigate to the EditBudgetScreen and wait for a result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBudgetScreen(
                            budgetId: budget.id, // Pass the budget id
                            budget: budget,      // Pass the whole budget object
                          ),
                        ),
                      );
                      if (result != null && result == true) {
                        setState(() {
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
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
        onPressed: navigateToAddBudget,
        child: const Icon(Icons.add),
      ),
    );
  }
}
