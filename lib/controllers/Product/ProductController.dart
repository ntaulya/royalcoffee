import 'package:flutter/material.dart';
import '../../services/Api/product/ProductServices.dart';
import '../../models/Product.dart';

class ProductController with ChangeNotifier {
  final ProductServices _productService = ProductServices();
  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchProducts({String? categoryId , String? searchQuery}) async {
    try {
      isLoading = true;
      notifyListeners();
      products = await _productService.getProducts(categoryId: categoryId ,saerch: searchQuery);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
