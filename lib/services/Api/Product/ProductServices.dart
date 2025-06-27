
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../SecureStorageService.dart';
import '../Config.dart';
import '../../../models/Product/Product.dart';

class ProductServices extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Product>> getProducts({String? categoryId , String? search}) async {
    try {
      String url = '${_config.baseUrl}/product';
      String? token = await _storageService.getToken();

      Map<String, String> requestHeaders = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(url).replace(queryParameters: {
        'id_categori': categoryId ?? '',
        'id_product': '',
        'search': search ?? '',
        'page': '1',
      });

      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(_config.timeout);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'get Product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      String url = '${_config.baseUrl}/product';
      String? token = await _storageService.getToken();

      Map<String, String> requestHeaders = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };
      
      final uri = Uri.parse(url).replace(queryParameters: {
        'id_categori':  '',
        'id_product': id,
        'search': '',
        'page': '1',
      });

      final response = await http.get(uri, headers: requestHeaders).timeout(_config.timeout);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];
        if (data.isEmpty) throw Exception('Produk tidak ditemukan');
        return Product.fromJson(data.first);
      } else {
        throw Exception(_config.getErrorMessage(response, 'get Product by ID'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Gagal mengambil produk detail: $e');
    }
  }
}
