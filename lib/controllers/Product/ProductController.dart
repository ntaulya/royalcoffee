import 'package:flutter/material.dart';
import '../../services/Api/product/ProductServices.dart';
import '../../models/Product/Product.dart';
import '../../models/Product/Variant.dart';
import 'dart:io';

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

  Future<void> toggleAddStock({
    required String productId,
    required String varianId,
    required int qty,
  }) async {
    try{
      await _productService.addStock(
        productId : productId,
        varianId : varianId,
        qty : qty,
      );
    }catch (e){
      errorMessage = e.toString();
    }finally{
      _setLoading(false);
    }
  }


Future<bool> updateProduct({
  required String productId,
  required String namaProduct,
  required String hargaProduct,
  required String descriptionProduct,
  required String kategoriId,
  required List<Map<String, dynamic>> varianProductList,
  Product? oldProduct,
}) async {
  String? newNama = namaProduct;
  String? newHarga = hargaProduct;
  String? newDeskripsi = descriptionProduct;
  String? newKategori = kategoriId;

  final filteredVarian = _filterVariantChanges(
    oldProduct?.variants ?? [],
    varianProductList,
  );

  if (oldProduct != null) {
    if (oldProduct.name == namaProduct) newNama = null;
    if (oldProduct.price == hargaProduct) newHarga = null;
    if ((oldProduct.description ?? '') == descriptionProduct) newDeskripsi = null;
    if (oldProduct.categories == kategoriId) newKategori = null;
  }

  _setLoading(true);
  try {
    await _productService.updateProduct( 
      productId: productId, // ✅ selalu dikirim 
      namaProduct: newNama, // hanya kalau berubah 
      hargaProduct: newHarga, // hanya kalau berubah 
      descriptionProduct: newDeskripsi, // hanya kalau berubah 
      kategoriId: newKategori, // hanya kalau berubah 
      varianProductList: filteredVarian.isEmpty ? null : filteredVarian,
      );
    return true;
  } catch (e) {
    errorMessage = e.toString();
    return false;
  } finally {
    _setLoading(false);
  }
}

List<Map<String, dynamic>> _filterVariantChanges(
  List<Variant> oldVariants,
  List<Map<String, dynamic>> editedVariants,
) {
  final Map<String, Variant> oldById = {
    for (final v in oldVariants) v.idVarian.toString(): v
  };

  final List<Map<String, dynamic>> result = [];

  for (final edited in editedVariants) {
    final String id = edited['vairan_id']?.toString() ?? '';
    if (id.isEmpty) continue;

    final old = oldById[id];
    final payload = <String, dynamic>{'vairan_id': id}; // ✅ selalu kirim varian_id
    bool changed = false;

    if (old == null) {
      // varian baru
      if (edited['nama_varian'] != null) { payload['nama_varian'] = edited['nama_varian']; changed = true; }
      if (edited['harga_varian'] != null) { payload['harga_varian'] = edited['harga_varian']; changed = true; }
      if (edited['stock_varian'] != null) { payload['stock'] = edited['stock_varian']; changed = true; }
      if (edited['is_primary'] != null) { payload['is_primary'] = edited['is_primary']; }
      if (edited['image_varian'] is File) {
        payload['image_varian'] = edited['image_varian'];
        payload['is_primary'] = edited['is_primary'] ?? 0; // ✅ wajib kirim is_primary jika ada file
        changed = true;
      }
    } else {
      // bandingkan dengan old
      if (edited['nama_varian'] != null && edited['nama_varian'] != old.namaVarian) {
        payload['nama_varian'] = edited['nama_varian'];
        changed = true;
      } 
      if (edited['harga_varian'] != null && edited['harga_varian'].toString() != old.hargaTambahan.toString()) {
        payload['harga_varian'] = edited['harga_varian']; changed = true;
      }
      if (edited['stock_varian'] != null && edited['stock_varian'].toString() != old.stock.toString()) {
        payload['stock'] = edited['stock_varian']; changed = true;
      }
      if (edited['is_primary'] != null && edited['is_primary'].toString() != old.isPrimary.toString()) {
        payload['is_primary'] = edited['is_primary']; changed = true;
      }

      // file baru
      if (edited['image_varian'] is File) {
        payload['image_varian'] = edited['image_varian'];
        payload['is_primary'] = edited['is_primary'] ?? (old.isPrimary ? 1 : 0); // ✅ wajib
        changed = true;
      }
    }

    if (changed) result.add(payload);
  }

  return result;
}



  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
