import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../SecureStorageService.dart';

class ImageHelper {
  static Future<Uint8List?> loadImage(String url) async {
    if (url.isEmpty) return null;

    try {
      final token = await SecureStorageService().getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Image load failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading image: $e');
    }

    return null;
  }
}
