import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/categories/categoryModel.dart';
import '../../models/transaction/transactionModel.dart';
import '../../services/categories/categoryService.dart';
import '../../services/transaction/transactionService.dart';

class TransactionFormScreen extends StatefulWidget {
  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'income';
  final _transactionDateController = TextEditingController();
  int? _selectedCategory;

  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService();
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch categories: $e')),
      );
    }
  }

  void _selectTransactionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _transactionDateController.text = formattedDate;
      });
    }
  }

  void _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      final userId = 1;
      final amount = int.tryParse(_amountController.text);

      if (userId == null || amount == null || _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter valid numbers and select a category')),
        );
        return;
      }

      final transaction = TransactionModel(
        userId: userId,
        categoryId: _selectedCategory!, // Use the selected category ID
        amount: amount,
        type: _type,
        transactionDate: _transactionDateController.text,
      );

      try {
        final success = await _transactionService.createTransaction(transaction);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transaction added successfully!')),
          );
          _formKey.currentState!.reset();
          setState(() {
            _selectedCategory = null;
            _type = 'income';
          });

          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter User ID';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Amount';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: _transactionDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Transaction Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectTransactionDate,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Transaction Date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTransaction,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}