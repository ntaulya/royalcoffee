import 'package:flutter/material.dart';
import '../../layout/BottomNavBarAdmin.dart';


// Belum Selesai
import '../Incoming/IncomingOrder.dart';
import '../Menu/MenuScreen.dart';
import '../Customer/Customer.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  int _selectedBottomNavIndex = 1;
  String _currentStep = "Menunggu Diproses";

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    // switch (index) {
    //   case 0:
    //     // Navigator.pushReplacement(
    //     //   context,
    //     //   MaterialPageRoute(builder: (context) => const IncomingOrder()),
    //     // );
    //     break;
    //   case 1:
    //     // Stay here
    //     break;
    //   case 2:
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const Menu()),
    //     );
    //     break;
    //   case 3:
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const Customer()),
    //     );
    //     break;
    // }
  }

  List<Map<String, dynamic>> _getAllOrders() {
    return [
      {
        "orderId": "ORD001",
        "customerName": "Muhammad Andi Syaifullah",
        "status": "Menunggu Diproses",
        "time": "10:30 AM",
        "statusColor": Colors.brown,
      },
      {
        "orderId": "ORD002",
        "customerName": "Siti Nurhaliza",
        "status": "Proses",
        "time": "09:45 AM",
        "statusColor": Colors.orange,
      },
      {
        "orderId": "ORD003",
        "customerName": "Ahmad Fauzi",
        "status": "Selesai",
        "time": "08:20 AM",
        "statusColor": Colors.green,
      },
      {
        "orderId": "ORD004",
        "customerName": "Dewi Sartika",
        "status": "Proses",
        "time": "07:15 AM",
        "statusColor": Colors.orange,
      },
    ];
  }

  List<Map<String, dynamic>> _getFilteredOrders(String status) {
    return _getAllOrders().where((order) => order["status"] == status).toList();
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
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildProgressIndicator() {
    final steps = ["Menunggu Diproses", "Proses", "Selesai"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = steps[index] == _currentStep;
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep = steps[index];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF4B1D0D) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    steps[index],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (index != steps.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final orders = _getFilteredOrders(status);
    if (orders.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Tidak ada pesanan dengan status \"$status\"",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
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
      ),
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
          "Cek Antrian & Proses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildProgressIndicator(),
          const SizedBox(height: 12),
          _buildOrderList(_currentStep),
        ],
      ),
    );
  }
}
