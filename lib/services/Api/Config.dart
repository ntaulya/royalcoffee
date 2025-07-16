import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/Login.dart';
import '../../models/Product/Product.dart';



class Config {
  // final String baseUrl = 'https://restapi.royalcafeandresto.com/api';
  final String baseUrl = "http://192.168.66.1/api";
  final Duration timeout = const Duration(seconds: 30);
  /// Default headers untuk semua request
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  

  String getErrorMessage(http.Response response, String action) {
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
}