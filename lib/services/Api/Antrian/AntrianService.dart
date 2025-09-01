import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Config.dart';
import '../../SecureStorageService.dart';
import '../../../models/Antrian/Antrian.dart';
import '../../../models/LogHistory.dart';
import '../../../models/LogHistoryDetail.dart';

class AntrianService extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Antrian>> getAntreanList({bool? section}) async {
    try {
      String url = '${_config.baseUrl}/product/history';
      String? token = await _storageService.getToken();

      final headers = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(url).replace(queryParameters: {
        'page': '1',
       'section': (section ?? false).toString(),
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
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<LogHistory>> getListNotification({String? page}) async{
     try {
      String url = '${_config.baseUrl}/product/checkOrder/history';
      String? token = await _storageService.getToken();
      final queryParams = <String, String>{};
      final headers = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      if (page != null) {
        queryParams['page'] = page;
      }

      final uri = Uri.parse(url).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers).timeout(_config.timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> antreanJson = data['data']['data'];
        return antreanJson.map((json) => LogHistory.fromJson(json)).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'getAntreanList'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

 Future<List<LogHistoryDetail>> getListNotificationDetail({required String idCheckout}) async {
    try {
      String url = '${_config.baseUrl}/product/checkOrder/history';
      String? token = await _storageService.getToken();

      final queryParams = {'id_checkout': idCheckout};
      final headers = {
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers).timeout(_config.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> antreanJson = data['data']['data'];
        print(antreanJson);
        return antreanJson.map((json) => LogHistoryDetail.fromJson(json)).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'getAntreanList'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
