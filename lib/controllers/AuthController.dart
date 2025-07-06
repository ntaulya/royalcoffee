import 'package:flutter/material.dart';
// View
import '../screens/Auth/LoginView.dart';
import '../screens/home/Dashboard.dart';
import '../screens/Auth/Otp.dart';
import '../screens/Auth/ResetPass.dart';
// Service
import '../services/Api/AuthService.dart';
import '../services/Api/UserService.dart';
import '../services/SecureStorageService.dart';

// Model 
import '../models/Profile.dart';


class AuthController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
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

  Future<Profile> getProfile(BuildContext context) async {
      final result = await _userService.getProfile();
      return result;
  }
  Future<void> updateProfile(
    BuildContext context, {
    required String namaLengkap,
    required String email,
    required String phone,
  }) async {
    try {
      await _userService.updateProfile(
        namaLengkap: namaLengkap,
        email: email,
        phone: phone,
      );
      final updatedProfile = await getProfile(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update profil: $e')),
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
      final result = await _authService.loginUser(email, password);
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
      final result = await _authService.registerUser(
        email,
        password,
        phone,
        username,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView(title : '')),
        (Route<dynamic> route) => false,
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


  Future<void> sendOtpToEmail(BuildContext context, String email) async {
    if (!AuthService.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }
    try {
      await _authService.forgotPassword(email);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  Otp(email: email)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP berhasil dikirim ke email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> verifyOtpFromApi({
    required BuildContext context,
    required String email,
    required String otp,
    int remainingTime = 0,
    String password = '',
  }) async {
    try {
      if (password.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPass(
              email: email, 
              otp: otp,
              remainingTime: remainingTime,
              ),
          ),
        );
      } else {
        await _authService.verifyOtp(email: email, otp: otp, password: password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password berhasil diubah')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView(title: '')),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verifikasi OTP gagal: $e')),
      );
    }
  }

  bool verifyOtp(BuildContext context, String otpCode) {
  
    if (otpCode.length == 6 && otpCode == '123456') {
     
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
