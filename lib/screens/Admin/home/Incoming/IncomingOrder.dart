import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../layout/SearchBox.dart';
import '../../layout/CustomTopBar.dart';

import '../../../../controllers/Order/OrderController.dart';
import '../../../../models/CheckOut/Order.dart';
import '../../../../services/Api/Product/CheckOrderService.dart';
import './DetailOrderPage.dart';

class IncomingOrder extends StatefulWidget {
  const IncomingOrder({super.key});

  @override
  State<IncomingOrder> createState() => _IncomingOrderState();
}

class _IncomingOrderState extends State<IncomingOrder> {
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;
  late OrderController _orderController;

  Timer? _pollingTimer;
  int _lastOrderCount = 0;

  @override
  void initState() {
    super.initState();
    _orderController = OrderController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndCheckOrders(); // Pertama kali fetch
      _startPolling();        // Mulai polling tiap 30 detik
      setState(() {
        _initialized = true;
      });
    });
  }

  void _onSearchSubmitted() {
    final query = _searchController.text.trim();
    _orderController.getOrders(
      context: context,
      search: query.isEmpty ? null : query,
    );
  }

  Future<void> _navigateToDetail(BuildContext context, dynamic orderId) async {
    try {
      final service = CheckOrderService();
      final orders = await service.getOrder(id: orderId.toString());

      if (orders.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order tidak ditemukan')),
        );
        return;
      }

      final order = orders.first;

      // ⬇️ Tangkap hasil navigasi (true = perlu refresh)
      final shouldRefresh = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailOrderPage(order: order),
        ),
      );

      if (shouldRefresh == true) {
        await _fetchAndCheckOrders(); // ⬅️ Refresh data order manual
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail order: $e')),
      );
    }
  }


  /// 🔁 Fetch orders dan cek apakah ada yang baru
  Future<void> _fetchAndCheckOrders() async {
    await _orderController.getOrders(context: context);
    final currentCount = _orderController.orders.length;

    if (_lastOrderCount != 0 && currentCount > _lastOrderCount) {
      final newOrders = currentCount - _lastOrderCount;
      _showNewOrderNotification(newOrders);
    }

    _lastOrderCount = currentCount;
  }

  /// 🔔 Menampilkan notifikasi jika ada order baru
  void _showNewOrderNotification(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔔 Ada $count pesanan baru!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// ⏱️ Memulai polling tiap 30 detik
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchAndCheckOrders();
    });
  }

  /// 🚫 Stop polling saat keluar
  @override
  void dispose() {
    _pollingTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildOrderItem(int index, Order order) {
    return InkWell(
      onTap: () => _navigateToDetail(context, order.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.brown, width: 0.8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.brown,
              child: Text(
                "${index + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.nama_pemesan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4B1D0D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.email ?? "Email tidak tersedia"} | ID: ${order.id}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderController>.value(
      value: _orderController,
      child: Consumer<OrderController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            appBar: const CustomTopBar(title: "Incoming Order"),
            body: Column(
              children: [
                SearchBox(
                  hintText: "Search Order using Email Customer",
                  controller: _searchController,
                  onSearchTap: _onSearchSubmitted,
                ),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.orders.isEmpty
                          ? const Center(child: Text("Belum ada data order"))
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: controller.orders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderItem(index, controller.orders[index]);
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
