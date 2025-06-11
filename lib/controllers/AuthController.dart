import 'package:flutter/material.dart';
// View
import '../screens/LoginView.dart';
import '../screens/home/Dashboard.dart';
// Service
import '../services/ApiService.dart';
import '../services/SecureStorageService.dart';


class AuthController {
  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();



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



  // Check Token
  Future<void> checkToken(BuildContext context) async{
    final token = await _storageService.getToken();
    if(token != null){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView(title: '')),
        );
    }
  }

  // LOGOUT
  Future<void> logOut(BuildContext context) async{
    await _storageService.deleteToken();
    checkToken(context);
  }

  /// LOGIN
  Future<void> login(BuildContext context) async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    try {
      final result = await _apiService.loginUser(email, password);
      _storageService.saveToken(result.token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
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
      final result = await _apiService.registerUser(
        email,
        password,
        phone,
        username,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil. Silakan login.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registrasi gagal: $e')));
    }
  }

  bool verifyOtp(BuildContext context, String otpCode) {
    // Kamu bisa ganti validasinya sesuai logika yang diinginkan
    if (otpCode.length == 4 && otpCode == '1234') {
      // Contoh kode OTP valid
      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kode OTP tidak valid')));
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
