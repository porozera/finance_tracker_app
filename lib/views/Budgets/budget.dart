import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: const Center(
        child: Text('Budget Page Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new budget
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}