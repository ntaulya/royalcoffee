import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

class Login {
  final String token;

  Login({required this.token});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      token: json['token'],
    );
  }
}
