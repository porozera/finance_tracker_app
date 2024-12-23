import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/budgets/budgetsModel.dart';
import '../../models/categories/categoryModel.dart';
import '../../models/savingGoals/savingGoalModel.dart';
import '../../services/budgets/budgetsService.dart';
import '../../services/categories/categoryService.dart';
import '../../services/savingGoals/savingGoalsService.dart';
import '../../services/transaction/transactionService.dart';
import '../../models/transaction/transactionModel.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _transactionService = TransactionService();

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<String> _types = ['income', 'expense'];


  bool _isLoading = false;
  List<CategoryModel> _categories = [];
  List<Budgets> _budgets = [];
  List<GoalModel> _goals = [];
  int? _selectedCategoryId;
  int? _selectedBudgetId;
  int? _selectedGoalId;
  String? _selectedType;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchbBudgets();
    _fetchbGoals(); // Fetch goals on init as well
  }

  Future<void> _fetchCategories() async {
    try {
      setState(() => _isLoading = true);

      final fetchedCategories = await CategoryService().fetchCategories();
      setState(() => _categories = fetchedCategories);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching categories: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchbBudgets() async {
    try {
      setState(() => _isLoading = true);

      final fetchedBudgets = await BudgetService().getBudgets();
      setState(() => _budgets = fetchedBudgets);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching budgets: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchbGoals() async {
    try {
      setState(() => _isLoading = true);

      final fetchedGoals = await GoalService().fetchGoals();
      setState(() => _goals = fetchedGoals);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching goals: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }


  void _createTransaction() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      setState(() => _isLoading = true);

      Map<String, dynamic> transactionData = {
        "user_id": 1,
        "title": _titleController.text,
        "amount": double.parse(_amountController.text),
        "description": _descriptionController.text,
        "category_id": _selectedCategoryId,
        "saving_goals": _selectedGoalId,
        "budget_id": _selectedBudgetId,
        "type": _selectedType,
        "transaction_date": _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null,
      };

      try {
        await _transactionService.createTransaction(transactionData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction added successfully!")),
        );
        Navigator.pop(context); // Navigate back to previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int?>(
                decoration: const InputDecoration(labelText: "Goals"),
                value: _selectedGoalId,
                items: _goals.map((goal) {
                  return DropdownMenuItem<int>(
                    value: goal.id,
                    child: Text(goal.goalName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedGoalId = value);
                },
                validator: (value) {
                  // if (value == null) {
                  //   return "Please select a goal";
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Budgets"),
                value: _selectedBudgetId,
                items: _budgets.map((budget) {
                  return DropdownMenuItem<int>(
                    value: budget.id,
                    child: Text(budget.currentAmount),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedBudgetId = value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a budget";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Type"),
                value: _selectedType, // Use the selected type variable
                items: _types.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value); // Update the selected type
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a type";
                  }
                  return null;
                },
                hint: const Text('Select a type'), // Add a hint
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an amount";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>( // Category dropdown fix
                decoration: const InputDecoration(labelText: "Category"),
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategoryId = value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a category";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "Date"),
                readOnly: true, // Prevent manual editing
                onTap: () => _selectDate(context), // Trigger the date picker
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _createTransaction,
                child: const Text("Add Transaction"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
