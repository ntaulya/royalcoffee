import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../layout/SearchBox.dart';
import '../../../../controllers/Order/OrderController.dart';
import '../../../../models/CheckOut/Order.dart';

class IncomingOrder extends StatefulWidget {
  const IncomingOrder({super.key});

  @override
  State<IncomingOrder> createState() => _IncomingOrderState();
}

class _IncomingOrderState extends State<IncomingOrder> {
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;

  void _onSearchSubmitted(BuildContext context) {
    final controller = Provider.of<OrderController>(context, listen: false);
    final query = _searchController.text.trim();
    controller.getOrders(
      context: context,
      search: query.isEmpty ? null : query,
    );
  }

  Widget _buildOrderItem(Order order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.brown, width: 0.8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${order.nama_pemesan}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF4B1D0D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.email ?? 'Email tidak tersedia',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            "ID: ${order.id}",
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider ditaruh di luar dan context baru digunakan di dalam builder
    return ChangeNotifierProvider(
      create: (_) => OrderController(),
      builder: (context, child) {
        // Jalankan fetch data hanya sekali setelah context aman
        if (!_initialized) {
          Provider.of<OrderController>(context, listen: false).getOrders(context: context);
          _initialized = true;
        }

        return Consumer<OrderController>(
          builder: (context, controller, _) {
            return Scaffold(
              backgroundColor: const Color(0xFFF9F9F9),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Incoming Order",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              body: Column(
                children: [
                  SearchBox(
                    hintText: "Search Order using Email Customer",
                    controller: _searchController,
                    onSearchTap: () => _onSearchSubmitted(context),
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
                                  return _buildOrderItem(controller.orders[index]);
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
