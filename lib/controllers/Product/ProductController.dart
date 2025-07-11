import 'package:flutter/material.dart';
import '../../services/Api/product/ProductServices.dart';
import '../../models/Product/Product.dart';

class ProductController with ChangeNotifier {
  final ProductServices _productService = ProductServices();

  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchProducts({String? categoryId, String? searchQuery}) async {
    try {
      isLoading = true;
      notifyListeners();
      products = await _productService.getProducts(
        categoryId: categoryId,
        search: searchQuery,
      );
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

  Future<void> createProduct({
    required String namaProduct,
    required String hargaProduct,
    required String descriptionProduct,
    required String kategoriId,
    required List<Map<String, dynamic>> varianProductList,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
     

      await _productService.createProduct(
        namaProduct: namaProduct,
        hargaProduct: hargaProduct,
        descriptionProduct: descriptionProduct,
        kategoriId: kategoriId,
        varianProductList: varianProductList,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
    } catch (e) {
      errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan produk: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> toggleProductStatus({
    required String productId,
    required String currentStatus,
    required String categoryId,
  }) async {
    final newStatus = currentStatus.toLowerCase() == 'aktif' ? 'non_aktif' : 'aktif';

    try {
      isLoading = true;
      notifyListeners();

      await _productService.updateProductStatus(
        productId: productId,
        statusProduct: newStatus,
      );
      await fetchProducts(categoryId: categoryId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
