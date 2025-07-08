import 'package:flutter/material.dart';

class IncomingOrder extends StatelessWidget {
  const IncomingOrder({super.key});

  List<Map<String, dynamic>> _getIncomingOrders() {
    return [
      {
        "orderId": "ORD006",
        "customerName": "Rina Sari",
        "items": ["Americano x2", "Cappuccino x1", "Croissant x1"],
        "total": "Rp 75.000",
        "time": "11:45 AM",
        "priority": "high",
        "orderType": "Dine In",
      },
      {
        "orderId": "ORD007",
        "customerName": "Dani Pratama",
        "items": ["Latte x1", "Sandwich x2"],
        "total": "Rp 65.000",
        "time": "11:30 AM",
        "priority": "medium",
        "orderType": "Take Away",
      },
      {
        "orderId": "ORD008",
        "customerName": "Maya Putri",
        "items": ["Espresso x3", "Cake x1"],
        "total": "Rp 85.000",
        "time": "11:15 AM",
        "priority": "high",
        "orderType": "Delivery",
      },
      {
        "orderId": "ORD009",
        "customerName": "Agus Setiawan",
        "items": ["Mocha x1", "Cookies x2"],
        "total": "Rp 55.000",
        "time": "11:00 AM",
        "priority": "low",
        "orderType": "Dine In",
      },
    ];
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getOrderTypeIcon(String orderType) {
    switch (orderType) {
      case 'Dine In':
        return Icons.restaurant;
      case 'Take Away':
        return Icons.shopping_bag;
      case 'Delivery':
        return Icons.delivery_dining;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildIncomingOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            width: 4,
            color: _getPriorityColor(order["priority"]),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header (same as before)...
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(order["priority"]).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order["orderId"],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(order["priority"]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _getOrderTypeIcon(order["orderType"]),
                      size: 16,
                      color: const Color(0xFF8B4A0C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order["orderType"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B4A0C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  order["time"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              order["customerName"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B1D0D),
              ),
            ),
            const SizedBox(height: 8),
            ...order["items"].map<Widget>((item) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B4A0C),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order["total"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4A0C),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showRejectDialog(context, order["orderId"]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                      ),
                      child: const Text("Tolak", style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _acceptOrder(context, order["orderId"]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4A0C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Terima", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _acceptOrder(BuildContext context, String orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Order $orderId diterima dan sedang diproses"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tolak Pesanan"),
        content: Text("Yakin ingin menolak order $orderId?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Order $orderId ditolak"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Tolak", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    final orders = _getIncomingOrders();
    return Scaffold(
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
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Tidak ada pesanan masuk", style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildIncomingOrderCard(context, orders[index]);
              },
            ),
    );
  }
}
