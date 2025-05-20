import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login.dart';

class ApiService {
  final String baseUrl = 'https://restapi.royalcafeandresto.com/api';

  /// Login user
  Future<Login> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Login Status: ${response.statusCode}');
    print('Login Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data']; // Ambil hanya bagian 'data'
      return Login.fromJson(data);
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  /// Register user
  Future<Login> registerUser(String email, String password, String phone, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'phone': phone,
        'username': username,
      }),
    );

    print('Register Status: ${response.statusCode}');
    print('Register Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      return Login.fromJson(data);
    } else {
      throw Exception('Register gagal: ${response.body}');
    }
  }
}
