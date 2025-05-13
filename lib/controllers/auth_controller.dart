import 'package:flutter/material.dart';
import '../screens/home/home-coffee.dart';

class AuthController {
  // Login Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register Controllers
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerUsernameController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  //OTP Controllers
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();

  void login(BuildContext context) {
    String email = loginEmailController.text;
    String password = loginPasswordController.text;

    if (email == 'admin@mail.com' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeCoffee()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau Password Salah')),
      );
    }
  }

  void register(BuildContext context) {
    String email = registerEmailController.text;
    String phone = registerPhoneController.text;
    String username = registerUsernameController.text;
    String password = registerPasswordController.text;
    String confirmPassword = registerConfirmPasswordController.text;

    if (password == confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register Berhasil, Silakan Login')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan Konfirmasi Password Tidak Sama'),
        ),
      );
    }
  }

  void resetPassword(BuildContext context) {
    final email = loginEmailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email tidak boleh kosong')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Link reset dikirim ke $email')));
  }

  bool verifyOtp(BuildContext context, String otpCode) {
  if (otpCode.length == 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP $otpCode diverifikasi')),
    );
    return true; // <- Tambahkan ini
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP harus 4 digit')),
    );
    return false; // <- Tambahkan ini
  }
}


  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerUsernameController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
  }
}
