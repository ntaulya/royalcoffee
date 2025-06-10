import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/login.dart';
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'https://restapi.royalcafeandresto.com/api';
  final Duration timeout = const Duration(seconds: 30);

  /// Default headers untuk semua request
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Login user
  Future<Login> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: defaultHeaders,
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(timeout);

      print('Login Status: ${response.statusCode}');
      print('Login Body: ${response.body}');

      return _handleAuthResponse(response, 'login');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  /// Register user
  Future<Login> registerUser(String email, String password, String phone, String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: defaultHeaders,
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'phone': phone.trim(),
          'nama_lengkap': username.trim(),
        }),
      ).timeout(timeout);

      print('Register Status: ${response.statusCode}');
      print('Register Body: ${response.body}');

      return _handleAuthResponse(response, 'register');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Register gagal: $e');
    }
  }

  /// Helper method untuk handle response authentication
  Login _handleAuthResponse(http.Response response, String action) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonResponse = jsonDecode(response.body);

        // Validasi struktur response
        if (jsonResponse['data'] == null) {
          throw Exception('Data tidak ditemukan dalam response');
        }

        final data = jsonResponse['data'];
        return Login.fromJson(data);
      } catch (e) {
        throw Exception('Format response tidak valid: $e');
      }
    } else {
      // Handle specific error codes
      String errorMessage = _getErrorMessage(response, action);
      throw Exception(errorMessage);
    }
  }

  /// Get specific error message based on status code
  String _getErrorMessage(http.Response response, String action) {
    try {
      final jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'] ?? 'Terjadi kesalahan';

      switch (response.statusCode) {
        case 400:
          return 'Data yang dikirim tidak valid: $message';
        case 401:
          return action == 'login'
              ? 'Email atau password salah'
              : 'Tidak memiliki akses: $message';
        case 422:
          return 'Validasi gagal: $message';
        case 500:
          return 'Terjadi kesalahan pada server';
        default:
          return '$action gagal: $message';
      }
    } catch (e) {
      return '$action gagal dengan kode: ${response.statusCode}';
    }
  }

  /// Logout user (optional - jika API mendukung)
  Future<void> logoutUser(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Logout gagal');
      }
    } catch (e) {
      // Logout error bisa diabaikan karena token akan dihapus dari local storage
      print('Logout error: $e');
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= 6; // Sesuaikan dengan requirement
  }

  /// Validate phone number
  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9+\-\s()]+').hasMatch(phone) && phone.length >= 10;
  }

  // ===== PRODUCT ENDPOINTS =====

  /// Get all products
  Future<List<Product>> getAllProducts({String? category, String? search}) async {
    try {
      String url = '$baseUrl/products';
      Map<String, String> queryParams = {};

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      Uri uri = Uri.parse(url);
      if (queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(
        uri,
        headers: defaultHeaders,
      ).timeout(timeout);

      print('Get Products Status: ${response.statusCode}');
      print('Get Products Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> productsJson = jsonResponse['data'] ?? [];

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(_getErrorMessage(response, 'get products'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  /// Get product by ID
  Future<Product> getProductById(int productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
        headers: defaultHeaders,
      ).timeout(timeout);

      print('Get Product Status: ${response.statusCode}');
      print('Get Product Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];

        if (productJson == null) {
          throw Exception('Produk tidak ditemukan');
        }

        return Product.fromJson(productJson);
      } else {
        throw Exception(_getErrorMessage(response, 'get product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    return getAllProducts(category: category);
  }

  /// Search products
  Future<List<Product>> searchProducts(String query) async {
    return getAllProducts(search: query);
  }

  /// Get available products only
  Future<List<Product>> getAvailableProducts({String? category}) async {
    try {
      final allProducts = await getAllProducts(category: category);
      return allProducts.where((product) => product.isAvailable).toList();
    } catch (e) {
      throw Exception('Gagal mengambil produk tersedia: $e');
    }
  }

  /// Create new product (Admin only - requires token)
  Future<Product> createProduct(Product product, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(product.toJson()),
      ).timeout(timeout);

      print('Create Product Status: ${response.statusCode}');
      print('Create Product Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];
        return Product.fromJson(productJson);
      } else {
        throw Exception(_getErrorMessage(response, 'create product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal membuat produk: $e');
    }
  }

  /// Update product (Admin only - requires token)
  Future<Product> updateProduct(int productId, Product product, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(product.toJson()),
      ).timeout(timeout);

      print('Update Product Status: ${response.statusCode}');
      print('Update Product Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];
        return Product.fromJson(productJson);
      } else {
        throw Exception(_getErrorMessage(response, 'update product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengupdate produk: $e');
    }
  }

  /// Delete product (Admin only - requires token)
  Future<void> deleteProduct(int productId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);

      print('Delete Product Status: ${response.statusCode}');
      print('Delete Product Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(_getErrorMessage(response, 'delete product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  /// Toggle product availability (Admin only - requires token)
  Future<Product> toggleProductAvailability(int productId, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/products/$productId/toggle-availability'),
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(timeout);

      print('Toggle Availability Status: ${response.statusCode}');
      print('Toggle Availability Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productJson = jsonResponse['data'];
        return Product.fromJson(productJson);
      } else {
        throw Exception(_getErrorMessage(response, 'toggle availability'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengubah ketersediaan produk: $e');
    }
  }

  /// Get product categories
  Future<List<String>> getProductCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
        headers: defaultHeaders,
      ).timeout(timeout);

      print('Get Categories Status: ${response.statusCode}');
      print('Get Categories Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> categoriesJson = jsonResponse['data'] ?? [];

        return categoriesJson.map((category) => category.toString()).toList();
      } else {
        throw Exception(_getErrorMessage(response, 'get categories'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  /// Get Coffee Products
  Future<List<Product>> getCoffeeProducts() async {
    return getAllProducts(category: 'Coffee');
  }
}