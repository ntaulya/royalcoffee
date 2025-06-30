import 'package:flutter/material.dart';
import 'package:royalcoffee/admin/layout/BottomNavBarAdmin.dart';
import 'package:royalcoffee/admin/screens/IncomingOrder.dart';
import 'package:royalcoffee/admin/screens/Customer.dart';
import 'package:royalcoffee/admin/screens/Menu.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> with SingleTickerProviderStateMixin {
  int _selectedBottomNavIndex = 1; // aktif di index ke-1 (Track Order)
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IncomingOrder()),
        );
        break;
      case 1:
        // Stay on Track Order
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

  Widget _buildOrderCard({
    required String orderId,
    required String customerName,
    required String status,
    required String time,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF8B4A0C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: Color(0xFF8B4A0C),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B1D0D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customerName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Data dummy untuk setiap tab
  List<Map<String, dynamic>> _getAllOrders() {
    return [
      {
        "orderId": "ORD001",
        "customerName": "Muhammad Andi Syaifullah",
        "status": "Sedang Dibuat",
        "time": "10:30 AM",
        "statusColor": Colors.orange,
      },
      {
        "orderId": "ORD002",
        "customerName": "Siti Nurhaliza",
        "status": "Siap Diambil",
        "time": "09:45 AM",
        "statusColor": Colors.green,
      },
      {
        "orderId": "ORD003",
        "customerName": "Ahmad Fauzi",
        "status": "Sedang Diantar",
        "time": "08:20 AM",
        "statusColor": Colors.blue,
      },
      {
        "orderId": "ORD004",
        "customerName": "Dewi Sartika",
        "status": "Selesai",
        "time": "07:15 AM",
        "statusColor": Colors.grey,
      },
      {
        "orderId": "ORD005",
        "customerName": "Budi Santoso",
        "status": "Sedang Dibuat",
        "time": "11:00 AM",
        "statusColor": Colors.orange,
      },
    ];
  }

  List<Map<String, dynamic>> _getFilteredOrders(String status) {
    if (status == "Semua") return _getAllOrders();
    return _getAllOrders().where((order) => order["status"] == status).toList();
  }

  Widget _buildOrderList(String status) {
    final orders = _getFilteredOrders(status);
    
    if (orders.isEmpty) {
      return Center(
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
              "Tidak ada order dengan status $status",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(
          orderId: order["orderId"],
          customerName: order["customerName"],
          status: order["status"],
          time: order["time"],
          statusColor: order["statusColor"],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Track Order",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF8B4A0C),
          indicatorWeight: 3,
          labelColor: const Color(0xFF8B4A0C),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: "Semua"),
            Tab(text: "Sedang Dibuat"),
            Tab(text: "Siap Diambil"),
            Tab(text: "Sedang Diantar"),
            Tab(text: "Selesai"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList("Semua"),
          _buildOrderList("Sedang Dibuat"),
          _buildOrderList("Siap Diambil"),
          _buildOrderList("Sedang Diantar"),
          _buildOrderList("Selesai"),
        ],
      ),
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onTap,
      ),
    );
  }
}