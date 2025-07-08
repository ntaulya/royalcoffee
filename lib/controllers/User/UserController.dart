import 'package:flutter/material.dart';
import '../../models/User/User.dart';
import '../../services/Api/UserService.dart';

class UserController with ChangeNotifier {
  final UserService _userService = UserService();

  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;

  final TextEditingController searchController = TextEditingController();

  /// Get all users (optionally with search)
  Future<void> getAllUsers({BuildContext? context}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _userService.getList(); 
      users = result;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pengguna berhasil dimuat')),
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data pengguna: $e')),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearUsers() {
    users.clear();
    notifyListeners();
  }

  void disposeController() {
    searchController.dispose();
  }
}
