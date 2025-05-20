import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

class Login {
  final String email;
  final String password;
  final String token;

  Login({
    required this.email,
    required this.password,
    required this.token,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password'],
      token: json['token'],
    );
  }
}
