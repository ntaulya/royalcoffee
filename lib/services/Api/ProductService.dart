/ lib/services/product_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Product.dart';
import 'config.dart';

class ProductService {
  final Config _config = Config();

  Future<List<Product>> getAllProducts({int category = 1, String? search}) async {
    try {
      String url = '${_config.baseUrl}/products';
      final queryParams = <String, String>{
        'id_categori': category.toString(),
        'id_product': '',
        'search': search ?? '',
        'page': '',
      };

      final uri = Uri.parse(url).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: _config.defaultHeaders)
          .timeout(_config.timeout);

      print('Get All Products: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> productsJson = jsonResponse['data'] ?? [];

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'get products'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  Future<Product> getProductById(int productId) async {
    try {
      final response = await http
          .get(Uri.parse('${_config.baseUrl}/products/$productId'),
              headers: _config.defaultHeaders)
          .timeout(_config.timeout);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];

        if (productJson == null) {
          throw Exception('Produk tidak ditemukan');
        }

        return Product.fromJson(productJson);
      } else {
        throw Exception(_config.getErrorMessage(response, 'get product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  Future<Product> createProduct(Product product, String token) async {
    try {
      final response = await http
          .post(
            Uri.parse('${_config.baseUrl}/products'),
            headers: {
              ..._config.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(product.toJson()),
          )
          .timeout(_config.timeout);

      print('Create Product: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];
        return Product.fromJson(productJson);
      } else {
        throw Exception(_config.getErrorMessage(response, 'create product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal membuat produk: $e');
    }
  }

  Future<Product> updateProduct(int productId, Product product, String token) async {
    try {
      final response = await http
          .put(
            Uri.parse('${_config.baseUrl}/products/$productId'),
            headers: {
              ..._config.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(product.toJson()),
          )
          .timeout(_config.timeout);

      print('Update Product: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];
        return Product.fromJson(productJson);
      } else {
        throw Exception(_config.getErrorMessage(response, 'update product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengupdate produk: $e');
    }
  }

  Future<void> deleteProduct(int productId, String token) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${_config.baseUrl}/products/$productId'),
            headers: {
              ..._config.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_config.timeout);

      print('Delete Product: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(_config.getErrorMessage(response, 'delete product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  Future<Product> toggleProductAvailability(int productId, String token) async {
    try {
      final response = await http
          .patch(
            Uri.parse('${_config.baseUrl}/products/$productId/toggle-availability'),
            headers: {
              ..._config.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_config.timeout);

      print('Toggle Product Availability: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];
        return Product.fromJson(productJson);
      } else {
        throw Exception(
            _config.getErrorMessage(response, 'toggle availability'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengubah ketersediaan produk: $e');
    }
  }

  Future<List<String>> getProductCategories() async {
    try {
      final response = await http
          .get(Uri.parse('${_config.baseUrl}/products/categories'),
              headers: _config.defaultHeaders)
          .timeout(_config.timeout);

      print('Get Categories: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> categoriesJson = jsonResponse['data'] ?? [];

        return categoriesJson.map((category) => category.toString()).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'get categories'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }
}