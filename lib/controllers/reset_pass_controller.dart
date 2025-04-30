import 'package:flutter/material.dart';

class ResetPassController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Variabel untuk mengontrol visibilitas password
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  
  // Toggle visibilitas password
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }
  
  // Toggle visibilitas konfirmasi password
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
  }
  
  // Validasi password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }
  
  // Validasi konfirmasi password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != newPasswordController.text) {
      return 'Password tidak sama';
    }
    return null;
  }
  
  // Method untuk reset password
  Future<bool> resetPassword(BuildContext context) async {
    try {
      String? passwordError = validatePassword(newPasswordController.text);
      if (passwordError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(passwordError)),
        );
        return false;
      }
      
      String? confirmError = validateConfirmPassword(confirmPasswordController.text);
      if (confirmError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(confirmError)),
        );
        return false;
      }
      
      // TODO: Implementasi reset password dengan API
      
      await Future.delayed(const Duration(seconds: 1));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah')),
      );
      
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah password: ${e.toString()}')),
      );
      return false;
    }
  }
  
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}