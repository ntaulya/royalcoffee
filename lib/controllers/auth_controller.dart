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

  // OTP Controllers
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeCoffee()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login berhasil! Selamat datang ${result.email}')),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil untuk ${result.email}. Silakan login.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
      );
    }
  }

  /// RESET PASSWORD (dummy)
  void resetPassword(BuildContext context) {
    final email = loginEmailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak boleh kosong')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link reset password dikirim ke $email')),
    );
  }

  /// VERIFIKASI OTP
  bool verifyOtp(BuildContext context, String otpCode) {
    if (otpCode.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP $otpCode diverifikasi')),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP harus 4 digit')),
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
