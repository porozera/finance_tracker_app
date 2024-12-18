import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: const Center(
        child: Text('Transaction Page Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new transaction
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}