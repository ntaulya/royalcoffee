import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Config.dart';
import '../../SecureStorageService.dart';
import '../../../models/CheckOut/Order.dart';
import '../../../models/CheckOut/ItemProduct.dart';



class CheckOrderService extends Config{
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();
  Fiture<List<Order>> getOrder({String? id, String? search}) async {
    try{
      String url = '${_config.baseUrl}/product/checkOrder';
      Map<String,String> requrestHeaders = {
        ..._config.defaultHeaders,
        'Authorization' : 'Bearer $token',
      };
      final uri = Uri.parse(url).replace(queryParameters:{
        'search' : search ?? '',
        'id_checkout' : '',
        'page' : '1',
      });

      final response = await http
        .get(uri,headers:requrestHeaders)
        .timeout(_config.timeout);
      print(reponse.statusCode);
      print(reponse.body);
    }on SocketException{
      throw Exception('Tidak ada koneksi internet');
    }on http.ClientException{
      throw Exception('Gagal terhubung ke server');
    }catch (e) {
      throw Exception('Gagal mengambil order: $e');
    }
  }
}
