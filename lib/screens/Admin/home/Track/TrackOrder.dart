import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../controllers/Antrian/AntrianController.dart';
import '../../../../models/Antrian/Antrian.dart';
import '../../layout/CustomTopBar.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({Key? key}) : super(key: key);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  final AntrianController _controller = AntrianController();
  String _currentStep = "Menunggu Diproses";

  @override
  void initState() {
    super.initState();
    _initLocale();
  }

  Future<void> _initLocale() async {
    await initializeDateFormatting('id_ID', null); // inisialisasi locale Indonesia
    await _loadData();
  }

  Future<void> _loadData() async {
    await _controller.fetchAntrean(section: true);
    setState(() {});
  }

  String _mapProcesToStatus(String proses) {
    switch (proses.trim().toLowerCase()) {
      case "dapur":
        return "Menunggu Diproses";
      case "waiters":
        return "Proses";
      case "selesai":
        return "Selesai";
      default:
        return proses;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu diproses':
        return Colors.brown;
      case 'proses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTanggal(String tanggal) {
    try {
      final dateTime = DateTime.parse(tanggal).toLocal();
      final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return tanggal;
    }
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

  Widget _buildOrderCard({
    required String orderId,
    required String customerName,
    required String status,
    required String time,
    required String tipePemesanan,
    required Color statusColor,
  }) {
    IconData tipeIcon;
    Color tipeColor;
    switch (tipePemesanan.toLowerCase()) {
      case 'dine_in':
        tipePemesanan = "Dine In";
        tipeIcon = Icons.restaurant;
        tipeColor = Colors.green;
        break;
      case 'take_away':
        tipePemesanan = "Take Away";
        tipeIcon = Icons.shopping_bag;
        tipeColor = Colors.orange;
        break;
      default:
        tipeIcon = Icons.help_outline;
        tipeColor = Colors.grey;
    }

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
                  customerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B1D0D),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(tipeIcon, size: 16, color: tipeColor),
                    const SizedBox(width: 6),
                    Text(
                      tipePemesanan.toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: tipeColor,
                      ),
                    ),
                  ],
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

  Widget _buildOrderList() {
    if (_controller.isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller.error != null) {
      return Expanded(
        child: Center(child: Text("Terjadi kesalahan: ${_controller.error}")),
      );
    }

    final filtered = _controller.antreanList.where((antrian) {
      final status = _mapProcesToStatus(antrian.proces);
      return status.toLowerCase() == _currentStep.toLowerCase();
    }).toList();

    if (filtered.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Tidak ada pesanan",
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
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          final status = _mapProcesToStatus(item.proces);
          return _buildOrderCard(
            orderId: item.idCheckout,
            customerName: item.namaUser,
            status: status,
            time: _formatTanggal(item.create_at),
            tipePemesanan: item.tipePemesanan,
            statusColor: _getStatusColor(status),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomTopBar(title: "Cek Antrian & Proses"),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildProgressIndicator(),
          const SizedBox(height: 12),
          _buildOrderList(),
        ],
      ),
    );
  }
}
