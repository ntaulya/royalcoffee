import 'package:flutter/material.dart';
import 'package:royalcoffee/admin/layout/BottomNavBarAdmin.dart';
import 'package:royalcoffee/admin/screens/TrackOrder.dart';
import 'package:royalcoffee/admin/screens/Customer.dart';
import 'package:royalcoffee/admin/screens/Menu.dart';

class IncomingOrder extends StatefulWidget {
  const IncomingOrder({super.key});

  @override
  State<IncomingOrder> createState() => _IncomingOrderState();
}

class _IncomingOrderState extends State<IncomingOrder> {
  int _selectedBottomNavIndex = 0; // aktif di index ke-0 (Incoming Order)

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Stay on Incoming Order
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TrackOrder()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Customer()),
        );
        break;
    }
  }

  // Data dummy untuk incoming orders
  List<Map<String, dynamic>> _getIncomingOrders() {
    return [
      {
        "orderId": "ORD006",
        "customerName": "Rina Sari",
        "items": ["Americano x2", "Cappuccino x1", "Croissant x1"],
        "total": "Rp 75.000",
        "time": "11:45 AM",
        "priority": "high", // high, medium, low
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

  Widget _buildIncomingOrderCard(Map<String, dynamic> order) {
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
            // Header
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
            
            // Customer name
            Text(
              order["customerName"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B1D0D),
              ),
            ),
            const SizedBox(height: 8),
            
            // Items
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 12),
            
            // Footer
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
                        // Reject order
                        _showRejectDialog(order["orderId"]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red,
                        elevation: 0,
                        minimumSize: const Size(60, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Tolak",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Accept order
                        _acceptOrder(order["orderId"]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4A0C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(60, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Terima",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
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

  void _acceptOrder(String orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Order $orderId diterima dan sedang diproses"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showRejectDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tolak Pesanan"),
          content: Text("Apakah Anda yakin ingin menolak pesanan $orderId?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Order $orderId ditolak"),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Tolak", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _getIncomingOrders();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Incoming Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Notification action
                },
                icon: const Icon(Icons.notifications_outlined, color: Colors.black),
              ),
              if (orders.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${orders.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tidak ada pesanan masuk",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pesanan baru akan muncul di sini",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 100),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildIncomingOrderCard(orders[index]);
              },
            ),
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onTap,
      ),
    );
  }
}