import 'package:flutter/material.dart';
import '../../models/Category.dart';
import '../../services/Api/Category/CategoryService.dart';

class CategoryController {
  final CategoryService _categoryService = CategoryService();

  Future<List<Category>> loadCategories() async {
    try {
      return await _categoryService.getCategories();
    } catch (e) {
      return []; // bisa juga lempar error, tapi disini kita return kosong
    }
  }
}