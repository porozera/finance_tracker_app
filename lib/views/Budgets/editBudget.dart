import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../controllers/budgets/budgetsController.dart';
import '../../models/budgets/budgetsModel.dart';

class EditBudgetScreen extends StatefulWidget {
  final int budgetId;
  final Budgets budget; // Change to accept Budgets object

  const EditBudgetScreen({
    super.key,
    required this.budgetId,
    required this.budget,
  });

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstAmountController = TextEditingController();
  final TextEditingController _currentAmountController = TextEditingController();
  final BudgetController _controller = BudgetController();

  @override
  void initState() {
    super.initState();
    // Set the initial values of the form fields using the passed Budgets object
    _firstAmountController.text = widget.budget.firstAmount.toString();
    _currentAmountController.text = widget.budget.currentAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'First Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _currentAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Current Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Update Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedBudget = {
        'user_id': 1, // Keep this static or make it dynamic as needed
        'first_amount': double.parse(_firstAmountController.text),
        'current_amount': double.parse(_currentAmountController.text),
      };

      // Call the updateBudget function
      try {
        await _controller.updateBudget(widget.budgetId, updatedBudget);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget updated successfully!')),
        );
        Navigator.pop(context); // Navigate back after successful update
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

}
