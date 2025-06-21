
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../SecureStorageService.dart';
import '../Config.dart';
import '../../../models/Category.dart';

class CategoryService extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Category>> getCategories() async {
    try {
      String url = '${_config.baseUrl}/categori';
      String? token = await _storageService.getToken();

      Map<String, String> requestHeaders = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(url).replace(queryParameters: {
        'id': '',
        'page': '1',
      });

      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(_config.timeout);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];
        return data.map((item) => Category.fromJson(item)).toList();
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
