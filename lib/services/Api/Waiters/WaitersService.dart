import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../SecureStorageService.dart';
import '../Config.dart';
import '../../../models/Waiter/WaiterItem.dart';

class WaitersService {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<WaiterItem>> getWaitersList() async {
    try {
      final String url = '${_config.baseUrl}/product/waiters';
      final String? token = await _storageService.getToken();

      final response = await http.get(
        Uri.parse(url).replace(queryParameters: {'page': '1'}),
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(_config.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rawOuterList = data['data']['data'];
        final List<WaiterItem> allItems = [];

        for (var innerList in rawOuterList) {
          for (var item in innerList) {
            allItems.add(WaiterItem.fromJson(item));
          }
        }

        return allItems;
      } else {
        throw Exception(_config.getErrorMessage(response, 'getWaitersList'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      print('🛑 Error di getWaitersList: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> updateStatusPesanan({
    required String idCheckout,
    required String idVarian,
  }) async {
    try {
      final String url = '${_config.baseUrl}/product/waiters';
      final String? token = await _storageService.getToken();

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id_checkout': idCheckout,
          'id_varian': idVarian,
        },
      ).timeout(_config.timeout);
      if (response.statusCode != 201) {
        throw Exception(_config.getErrorMessage(response, 'updateStatusPesanan'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      print('🛑 Error di updateStatusPesanan: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
