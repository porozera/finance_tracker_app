import 'package:flutter/material.dart';
import 'package:finance_tracker_app/views/budget.dart';
import 'package:finance_tracker_app/views/savingGoals.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TransactionPageContent(),
    const BudgetPage(),
    const SavingGoalsPage(),
  ];

  // List of titles corresponding to each page
  final List<String> _pageTitles = [
    'Transaction',
    'Budget',
    'Saving Goals',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(_pageTitles[_currentIndex]),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => setState(() => _currentIndex = 0),
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () => setState(() => _currentIndex = 1),
                icon: const Icon(Icons.attach_money), // Icon for Budget
              ),
              IconButton(
                onPressed: () => setState(() => _currentIndex = 2),
                icon: const Icon(Icons.savings), // Icon for Saving Goals
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionPageContent extends StatelessWidget {
  const TransactionPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Transaction Page Content'),
    );
  }
}
