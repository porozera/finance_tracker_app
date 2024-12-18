import 'package:flutter/material.dart';

class SavingGoalsPage extends StatefulWidget {
  const SavingGoalsPage({Key? key}) : super(key: key);

  @override
  State<SavingGoalsPage> createState() => _SavingGoalsPageState();
}

class _SavingGoalsPageState extends State<SavingGoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saving Goals'),
      ),
      body: const Center(
        child: Text('Saving Goals Page Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new saving goal
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}