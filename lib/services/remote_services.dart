import 'dart:convert';
import 'package:royalcoffee/models/login.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  Future<List<Login>?> getPosts() async {
    var client = http.Client();

    // Sesuaikan endpoint dengan URL yang tepat untuk data login
    var uri = Uri.parse('https://restapi.royalcafeandresto.com/api/login');
    print(uri);
    
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      
      // Asumsikan bahwa API mengembalikan array/list
      List<dynamic> jsonList = jsonMap['data']; // Sesuaikan dengan struktur JSON Anda
      return jsonList.map((item) => Login.fromJson(item)).toList();
    } else {
      return null;
    }
  }
}