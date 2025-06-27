import 'package:flutter/material.dart';
import '../../services/Api/product/ProductServices.dart';
import '../../models/Product/Product.dart';

class ProductController with ChangeNotifier {
  final ProductServices _productService = ProductServices();
  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchProducts({String? categoryId , String? searchQuery}) async {
    try {
      isLoading = true;
      notifyListeners();
      products = await _productService.getProducts(categoryId: categoryId ,search: searchQuery);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<Product?> fetchProductDetail(String productId) async {
    try {
      isLoading = true;
      notifyListeners();
      final product = await _productService.getProductById(productId);
      errorMessage = null;
      return product;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
