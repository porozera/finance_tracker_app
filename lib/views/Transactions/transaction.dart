import 'package:finance_tracker_app/controllers/transaction/transactionController.dart';
import 'package:finance_tracker_app/models/transaction/transactionModel.dart';
import 'package:finance_tracker_app/services/transaction/transactionService.dart';
import 'package:flutter/material.dart';

import 'addTransaction.dart';
import 'editTransaction.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TransactionController _transactionController = TransactionController();
  final TransactionService _transactionService = TransactionService();
  List<TransactionModel> transactions = [];
  bool isLoading = true;

  Future<void> fetchTransactions() async {
    try {
      final data = await _transactionService.fetchTransactions();
      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching transaction: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return InkWell( // Wrap ListTile in InkWell
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTransactionPage(transactionId:transaction.id,transaction: transaction), // Pass transaction data
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.blueGrey.shade50,
              child: ListTile(
                title: Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${transaction.category.name}'),
                  ],
                ),
                trailing: Text(
                  'Rp${transaction.amount}',
                  style: TextStyle(
                    color: transaction.type == 'income' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AddTransactionPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}