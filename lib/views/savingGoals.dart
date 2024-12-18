import 'package:flutter/material.dart';

class SavingGoalsPage extends StatefulWidget {
  const SavingGoalsPage({super.key});

  @override
  State<SavingGoalsPage> createState() => _SavingGoalsPageState();
}

class _SavingGoalsPageState extends State<SavingGoalsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center( // Remove Scaffold here
      child: Text('Your Saving Goals Content Here'),
    );
  }
}
