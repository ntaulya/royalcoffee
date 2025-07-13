import 'package:flutter/material.dart';
import '../../../models/CheckOut/Order.dart';
import '../../../services/Api/Product/CheckOrderService.dart';

class OrderController with ChangeNotifier {
  final CheckOrderService _orderService = CheckOrderService();

  List<Order> orders = [];
  bool isLoading = false;

  Future<void> getOrders({BuildContext? context, String? search}) async {
    try {
      isLoading = true;
      notifyListeners();

      orders = await _orderService.getOrder(search: search);
    } catch (e) {
      debugPrint("Error getOrders: $e");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
