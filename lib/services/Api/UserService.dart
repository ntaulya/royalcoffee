// lib/services/user_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SecureStorageService.dart';
import 'Config.dart';

// model
import '../../models/Profile.dart';
import '../../models/User/User.dart';

class UserService extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  Future<List<User>> getList() async {
    try {
        String url = '${_config.baseUrl}/user';
        String? token = await _storageService.getToken();
        Map<String, String> requestHeaders = {
            ..._config.defaultHeaders,
            'Authorization': 'Bearer $token',
        };

        final uri = Uri.parse(url).replace(queryParameters: {
            'search': "",
            'page' : "",
            'limit' : "",
        });

        final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(_config.timeout);
        if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            final List<dynamic> dataList = jsonResponse['data']['data'];
            return dataList.map((item) => User.fromJson(item)).toList();
        } else {
            throw Exception(_config.getErrorMessage(response, 'get User'));
        }
    } on SocketException {
        throw Exception('Tidak ada koneksi internet');
    } on http.ClientException {
        throw Exception('Gagal terhubung ke server');
    } catch (e) {
        throw Exception('Gagal mengambil data profil: $e');
    }
  }


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
  Future<void> updateProfile({
    required String namaLengkap,
    required String email,
    required String phone,
    }) 
    async {
    try {
        String url = '${_config.baseUrl}/user/detail';
        String? token = await _storageService.getToken();

        Map<String, String> headers = {
          ..._config.defaultHeaders,
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        };

        final body = {
          'nama_lengkap': namaLengkap,
          'email': email,
          'phone': phone,
          'password': '',
          'user_id': ''
        };

        final response = await http
            .patch(Uri.parse(url), headers: headers, body: body)
            .timeout(_config.timeout);
        if (response.statusCode != 201) {
          throw Exception(_config.getErrorMessage(response, 'update profile'));
        }
    } on SocketException {
        throw Exception('Tidak ada koneksi internet');
    } catch (e) {
        throw Exception('Gagal update profil: $e');
    }
  }
}