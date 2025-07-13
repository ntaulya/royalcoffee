import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Config.dart';
import '../../SecureStorageService.dart';
import '../../../models/CheckOut/Order.dart';
import '../../../models/CheckOut/ItemProduct.dart';
import '../../../models/CartItem.dart';



class CheckOrderService extends Config{
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<Order>> getOrder({String? id, String? search}) async {
    try{
      String url = '${_config.baseUrl}/product/checkOrder';
      String? token = await _storageService.getToken();

      Map<String,String> requrestHeaders = {
        ..._config.defaultHeaders,
        'Authorization' : 'Bearer $token',
      };

      
      
      final uri = Uri.parse(url).replace(queryParameters:{
        'search' : search ?? '',
        'id_checkout' : id ?? '',
        'page' : '1',
      });
      

      final response = await http
          .get(uri, headers: requrestHeaders)
          .timeout(_config.timeout);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> ordersJson = jsonData['data']['data'];
        return ordersJson.map((orderJson) => Order.fromJson(orderJson)).toList();
    } else {
      throw Exception(_config.getErrorMessage(response, 'getOrder'));
    }
    }on SocketException{
      throw Exception('Tidak ada koneksi internet');
    }on http.ClientException{
      throw Exception('Gagal terhubung ke server');
    }catch (e) {
      print(e);
      throw Exception('Gagal mengambil order: $e');
    }
  }
  
  Future<void> checkoutOrder({
    required String tipePemesanan,
    required String notes,
    required List<CartItem> products,
  }) async {
    try {
      String url = '${_config.baseUrl}/product/carts';
      String? token = await _storageService.getToken();

      var uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);

     
      request.headers.addAll({
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
        
      });

     
      request.fields['tipe_pemesanan'] = tipePemesanan;
      request.fields['notes'] = notes;
      request.fields['product'] = ''; 

     
      for (int i = 0; i < products.length; i++) {
        request.fields['product[$i][product_id]'] = products[i].productId.toString();
        request.fields['product[$i][id_varian]'] = products[i].variantId.toString();
        request.fields['product[$i][qty]'] = products[i].quantity.toString();
      }

     
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(_config.getErrorMessage(response, 'checkout'));
      }

    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal melakukan checkout: $e');
    }
  }

  Future<void> confirmPayment({
    required String idCheckout,
    required String methodPembayaran,
    required int nominalPembayaran,
  }) async {
    try {
      String url = '${_config.baseUrl}/product/carts/confirm';
      String? token = await _storageService.getToken();

      var uri = Uri.parse(url);
      var response = await http.patch(
        uri,
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id_checkout': idCheckout,
          'method_pembayaran': methodPembayaran,
          'nominal_pembayaran': nominalPembayaran.toString(),
        },
      );

      print("🔁 Response confirm: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(_config.getErrorMessage(response, 'confirmPayment'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal melakukan konfirmasi pembayaran: $e');
    }
  }
}
