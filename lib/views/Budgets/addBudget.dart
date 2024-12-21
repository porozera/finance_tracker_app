import 'package:flutter/material.dart';
import '../../controllers/budgets/budgetsController.dart';


class BudgetsAddScreen extends StatefulWidget {
  const BudgetsAddScreen({super.key});

  @override
  _BudgetsAddScreenState createState() => _BudgetsAddScreenState();
}

class _BudgetsAddScreenState extends State<BudgetsAddScreen> {
  final BudgetController _controller = BudgetController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstAmountController = TextEditingController();

  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final budgetData = {
        'user_id':1,
        'first_amount': _firstAmountController.text,
        'current_amount': _firstAmountController.text, // Assuming it starts the same as firstAmount
      };

      try {
        await _controller.addBudget(budgetData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget created successfully!')),
        );
        Navigator.pop(context); // Navigate back after successful creation
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}