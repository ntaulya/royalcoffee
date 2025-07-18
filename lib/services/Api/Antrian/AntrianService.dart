import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Config.dart';
import '../../SecureStorageService.dart';
import '../../../models/Antrian/Antrian.dart';

class AntrianService extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Antrian>> getAntreanList() async {
    try {
      String url = '${_config.baseUrl}/product/history';
      String? token = await _storageService.getToken();

      final headers = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(url).replace(queryParameters: {
        'page': '1',
      });

      final response = await http.get(uri, headers: headers).timeout(_config.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> antreanJson = data['data']['data'];
        return antreanJson.map((json) => Antrian.fromJson(json)).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'getAntreanList'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server');
    } catch (e) {
      print('🛑 Error di AntreanService: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
