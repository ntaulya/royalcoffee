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
  Future<Order?> getOrderById(String id, {BuildContext? context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _orderService.getOrder(id: id);
      return data.isNotEmpty ? data.first : null;
    } catch (e) {
      debugPrint("Error getOrderById: $e");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> confirmPayment({
    required String idCheckout,
    required String methodPembayaran,
    required int nominalPembayaran,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _orderService.confirmPayment(
        idCheckout: idCheckout,
        methodPembayaran: methodPembayaran,
        nominalPembayaran: nominalPembayaran,
      );

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Konfirmasi pembayaran berhasil")),
        );
      }

      await getOrders(context: context);

    } catch (e) {
      debugPrint("❌ Error confirmPayment: $e");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal konfirmasi: $e")),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }Future<void> deleteOrder({
    required String idCheckout,
    required String password,
    BuildContext? context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _orderService.deleteOrder(
        idCheckout: idCheckout,
        password: password,
      );

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pesanan berhasil dihapus")),
        );
      }

      await getOrders(context: context);
    } catch (e) {
      debugPrint("❌ Error deleteOrder: $e");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus pesanan: $e")),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
