// lib/services/user_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SecureStorageService.dart';
import 'Config.dart';

// model
import '../../models/Profile.dart';

class UserService extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();


  Future<Profile> getProfile() async {
    try {
        String url = '${_config.baseUrl}/user/detail';
        String? token = await _storageService.getToken();
        Map<String, String> requestHeaders = {
            ..._config.defaultHeaders,
            'Authorization': 'Bearer $token',
        };

        final uri = Uri.parse(url).replace(queryParameters: {
            'id': null,
        });

        final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(_config.timeout);


        if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            final data = jsonResponse['data'];
            return Profile.fromJson(data);
        } else {
            throw Exception(_config.getErrorMessage(response, 'get profile'));
        }
    } on SocketException {
        throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
        throw Exception('Gagal terhubung ke server');
    } catch (e) {
        throw Exception('Gagal mengambil data profil: $e');
    }
  }
}