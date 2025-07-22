import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/Login.dart';
import '../../models/Product/Product.dart';
import '../../screens/Auth/LoginView.dart';
import './UserService.dart';
import '../SecureStorageService.dart';



class Config {
  final String baseUrl = "http://192.168.1.4/api";
  final Duration timeout = const Duration(seconds: 30);
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<void> handleUnauthorized(http.Response response) async {
    if (response.statusCode == 401) {
      final SecureStorageService _storageService = SecureStorageService();
      await _storageService.deleteToken();
      throw Exception('Token tidak valid. Silakan login ulang.');
    }
  } 

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