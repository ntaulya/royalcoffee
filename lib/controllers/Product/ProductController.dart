import 'package:flutter/material.dart';
import '../../services/Api/product/ProductServices.dart';
import '../../models/Product/Product.dart';

class ProductController with ChangeNotifier {
  final ProductServices _productService = ProductServices();

  List<Product> products = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool get isEndReached => !hasMore;
  bool hasMore = true;
  int currentPage = 1;
  String? lastCategoryId;
  String? lastSearchQuery;
  String? errorMessage;

  Future<void> fetchInitialProducts({String? categoryId, String? searchQuery}) async {
    _setLoading(true);
    currentPage = 1;
    hasMore = true;
    lastCategoryId = categoryId;
    lastSearchQuery = searchQuery;

    try {
      final fetched = await _productService.getProducts(
        categoryId: categoryId,
        search: searchQuery,
        page: currentPage,
      );

      products = fetched;
      hasMore = fetched.isNotEmpty;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      products = [];
      hasMore = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMoreProducts({String? categoryId}) async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = currentPage + 1;
      print("🔄 Fetching more products for page: ${currentPage + 1}");
      final fetched = await _productService.getProducts(
        categoryId: categoryId ?? lastCategoryId,
        search: lastSearchQuery,
        page: nextPage, // <-- INI YANG PENTING
      );

      if (fetched.isNotEmpty) {
        products.addAll(fetched);
        currentPage = nextPage; // simpan page terbaru
        hasMore = true;
      } else {
        hasMore = false;
      }
    } catch (e) {
      errorMessage = e.toString();
      hasMore = false;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<Product?> fetchProductDetail(int categoryId, String productId) async {
    _setLoading(true);
    try {
      final product = await _productService.getProductById(categoryId, productId);
      errorMessage = null;
      return product;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createProduct({
    required String namaProduct,
    required String hargaProduct,
    required String descriptionProduct,
    required String kategoriId,
    required List<Map<String, dynamic>> varianProductList,
  }) async {
    _setLoading(true);
    try {
      await _productService.createProduct(
        namaProduct: namaProduct,
        hargaProduct: hargaProduct,
        descriptionProduct: descriptionProduct,
        kategoriId: kategoriId,
        varianProductList: varianProductList,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleProductStatus({
    required String productId,
    required String currentStatus,
    required String categoryId,
  }) async {
    final newStatus = currentStatus.toLowerCase() == 'aktif' ? 'non_aktif' : 'aktif';

    _setLoading(true);
    try {
      await _productService.updateProductStatus(
        productId: productId,
        statusProduct: newStatus,
      );
      await fetchInitialProducts(categoryId: categoryId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
