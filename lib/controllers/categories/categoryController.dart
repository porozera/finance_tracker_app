import 'package:flutter/material.dart';
import '../../models/categories/categoryModel.dart';
import '../../services/categories/categoryService.dart';


class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.fetchCategories();
    } catch (e) {
      throw Exception('Failed to fetch categories');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
