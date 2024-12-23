import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/categories/categoryModel.dart';


class CategoryService {
  final String baseUrl = 'http://10.0.2.2:8000/api/categories';

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      rethrow;
    }
  }
}
