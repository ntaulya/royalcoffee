import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/login.dart';
import 'Config.dart';

class AuthService extends Config {

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

      return _handleAuthResponse(response, 'login');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server');
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  Future<Login> registerUser(
      String email, String password, String phone, String username) async {
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

  Login _handleAuthResponse(http.Response response, String action) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['data'] == null) {
          throw Exception('Data tidak ditemukan');
        }
        final data = jsonResponse['data'];
        return Login.fromJson(data);
      } catch (e) {
        throw Exception('Format response tidak valid: $e');
      }
    } else {
      String errorMessage = getErrorMessage(response, action);
      throw Exception(errorMessage);
    }
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9+\-\s()]+').hasMatch(phone) && phone.length >= 10;
  }
}