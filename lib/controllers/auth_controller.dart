import 'package:flutter/material.dart';
import '../screens/home/home-coffee.dart';
import '../services/api_helper.dart';

class AuthController {
  final ApiService _apiService = ApiService();

  // Login Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register Controllers
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerUsernameController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  // OTP Controllers (opsional)
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();

  /// LOGIN
  Future<void> login(BuildContext context) async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    try {
      final result = await _apiService.loginUser(email, password);
      print('Token: ${result.token}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeCoffee()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e')),
      );
    }
  }

  /// REGISTER
  Future<void> register(BuildContext context) async {
    final email = registerEmailController.text.trim();
    final phone = registerPhoneController.text.trim();
    final username = registerUsernameController.text.trim();
    final password = registerPasswordController.text;
    final confirmPassword = registerConfirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Konfirmasi tidak sama')),
      );
      return;
    }

    try {
      final result = await _apiService.registerUser(email, password, phone, username);
      print('Token: ${result.token}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil. Silakan login.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
      );
    }
  }

  bool verifyOtp(BuildContext context, String otpCode) {
  // Kamu bisa ganti validasinya sesuai logika yang diinginkan
  if (otpCode.length == 4 && otpCode == '1234') {
    // Contoh kode OTP valid
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP tidak valid')),
    );
    return false;
  }
}


  /// DISPOSE semua controller
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerUsernameController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
  }
}