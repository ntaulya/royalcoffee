import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';


import '../../SecureStorageService.dart';
import '../Config.dart';
import '../../../models/Product/Product.dart';
import '../../../models/Product/Pajak.dart';

class ProductServices extends Config {
  final Config _config = Config();
  final SecureStorageService _storageService = SecureStorageService();

  // Get All Products
  Future<List<Product>> getProducts({String? categoryId, String? search}) async {
    try {
      String url = '${_config.baseUrl}/product';
      String? token = await _storageService.getToken();

      final uri = Uri.parse(url).replace(queryParameters: {
        'id_categori': categoryId ?? '',
        'id_product': '',
        'search': search ?? '',
        'page': '1',
      });

      final response = await http.get(
        uri,
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(_config.timeout);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(_config.getErrorMessage(response, 'get Product'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }

  // Get Single Product by ID
  Future<Product> getProductById(int idCategori ,String id) async {
    try {
      String url = '${_config.baseUrl}/product';
      String? token = await _storageService.getToken();
      final uri = Uri.parse(url).replace(queryParameters: {
        'id_categori': idCategori.toString(),
        'id_product': id.toString(),
        'search': '',
        'page': '1',
      });

      final response = await http.get(
        uri,
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(_config.timeout);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data']['data'];
        print(data);
        if (data.isEmpty) throw Exception('Produk tidak ditemukan');
        return Product.fromJson(data.first);
      } else {
        throw Exception(_config.getErrorMessage(response, 'get Product by ID'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal mengambil produk detail: $e');
    }
  }

  // Get Pajak
  Future<Pajak> getCalculationPajak({int? totalBelanjaan}) async {
    try {
      String url = '${_config.baseUrl}/product/pajak';
      String? token = await _storageService.getToken();

      final uri = Uri.parse(url).replace(queryParameters: {
        'total': (totalBelanjaan ?? 0).toString(),
      });

      final response = await http.get(
        uri,
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(_config.timeout);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Pajak.fromJson(jsonResponse['data']);
      } else {
        throw Exception(_config.getErrorMessage(response, 'get Pajak'));
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal mengambil pajak: $e');
    }
  }

  Future<void> createProduct({
    required String namaProduct,
    required String hargaProduct,
    required String descriptionProduct,
    required String kategoriId,
    required List<Map<String, dynamic>> varianProductList,
  }) async {
    try {
      String url = '${_config.baseUrl}/product/create';
      String? token = await _storageService.getToken();

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        ..._config.defaultHeaders,
        'Authorization': 'Bearer $token',
      });

      // Data utama produk
      request.fields['nama_product'] = namaProduct;
      request.fields['harga_product'] = hargaProduct;
      request.fields['description_product'] = descriptionProduct;
      request.fields['kategori_id'] = kategoriId;

      // Tambah varian
      for (int i = 0; i < varianProductList.length; i++) {
        final varian = varianProductList[i];
        final File imageFile = varian['image_varian'];

        if (!imageFile.existsSync()) {
          throw Exception('Gambar varian ke-${i + 1} tidak ditemukan');
        }

        final mimeType = lookupMimeType(imageFile.path);
        if (mimeType != 'image/png') {
          throw Exception('File varian ke-${i + 1} bukan PNG');
        }

        // Tambahkan field varian
        request.fields['varian_product[$i][nama_varian]'] = varian['nama_varian'];
        request.fields['varian_product[$i][harga_varian]'] = varian['harga_varian'].toString();
        request.fields['varian_product[$i][stock_varian]'] = varian['stock_varian'].toString();
        request.fields['varian_product[$i][is_primary]'] = varian['is_primary'].toString();

        // Tambahkan file varian
        request.files.add(http.MultipartFile(
          'varian_product[$i][image_varian]',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: path.basename(imageFile.path),
          contentType: MediaType('image', 'png'),
        ));
      }

      final response = await request.send();

      if (response.statusCode != 201) {
        final resBody = await response.stream.bytesToString();
        try {
          final json = jsonDecode(resBody);
          throw Exception(json['message'] ?? 'Gagal membuat produk');
        } catch (_) {
          throw Exception('Gagal membuat produk: $resBody');
        }
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal membuat produk: $e');
    }
  }
  Future<void> updateProductStatus({
    required String productId,
    required String statusProduct, 
  }) async {
    try {
      String url = '${_config.baseUrl}/product/status';
      String? token = await _storageService.getToken();

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          ..._config.defaultHeaders,
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'product_id': productId,
          'status_product': statusProduct,
        },
      ).timeout(_config.timeout);
      if (response.statusCode != 201) {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal memperbarui status produk');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal mengubah status produk: $e');
    }
  }
}