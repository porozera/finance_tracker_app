import 'package:finance_tracker_app/views/Budgets/budget.dart';
import 'package:finance_tracker_app/views/SavingGoals/savingGoals.dart';
import 'package:finance_tracker_app/views/Transactions/addTransaction.dart';
import 'package:finance_tracker_app/views/Transactions/transaction.dart';
import 'package:flutter/material.dart';

import 'package:finance_tracker_app/views/Budgets/budget.dart';
import 'package:finance_tracker_app/views/SavingGoals/savingGoals.dart';
import 'package:finance_tracker_app/views/Transactions/transaction.dart';
import 'package:flutter/material.dart';

import 'package:finance_tracker_app/views/Budgets/budget.dart';
import 'package:finance_tracker_app/views/SavingGoals/savingGoals.dart';
import 'package:finance_tracker_app/views/Transactions/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    const TransactionPage(),
    const BudgetPage(),
    const SavingGoalsPage(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routes: {
        '/addTransaction': (context) => TransactionFormScreen(),
      },
      home: Scaffold(
        body: IndexedStack( // Use IndexedStack to display pages
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving Goals',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueGrey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}