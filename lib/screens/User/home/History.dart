import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/HistoryController.dart';
import '../../../models/LogHistory.dart';
import './HistoryPage.dart';

class History extends StatefulWidget {
  final Function(int) onItemSelected;

  const History({super.key, required this.onItemSelected});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final HistoryController _controller = HistoryController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _controller.getHistory(); 

    
    _refreshTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      _controller.getHistory();
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); 
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy, HH:mm").format(date.toLocal());
  }

  bool isExpired(LogHistory order) {
    final now = DateTime.now();
    final difference = now.difference(order.createdAt);
    return order.statusPemesanan.toLowerCase() == "detail" &&
        difference.inMinutes > 30;
  }

  bool isWaiting(LogHistory order) {
    final now = DateTime.now();
    final difference = now.difference(order.createdAt);
    return order.statusPemesanan.toLowerCase() == "detail" &&
        difference.inMinutes <= 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => widget.onItemSelected(0),
        ),
        title: const Text(
          "History Pesanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<LogHistory>>(
        stream: _controller.antrianStream,
        builder: (context, snapshot) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text("Belum ada pesanan."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = orders[index];
              final expired = isExpired(order);
              final waiting = isWaiting(order);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: expired
                      ? Border.all(color: Colors.red, width: 1.2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: expired
                        ? Colors.red[100]
                        : waiting
                            ? Colors.orange[100]
                            : Colors.brown[100],
                    child: expired
                        ? Icon(Icons.close, color: Colors.red[700], size: 28)
                        : waiting
                            ? Icon(Icons.history,
                                color: Colors.orange[700], size: 28)
                            : (order.imagePath.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      order.imagePath,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.receipt_long,
                                        color: Colors.brown[700],
                                      ),
                                    ),
                                  )
                                : Icon(Icons.receipt_long,
                                    color: Colors.brown[700])),
                  ),
                  title: Text(
                    "Pesanan : ${formatDate(order.createdAt)}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    expired
                        ? "Status: Expired\nJumlah item: ${order.jumlahItem}"
                        : waiting
                            ? "Status: Menunggu\nJumlah item: ${order.jumlahItem}"
                            : "Status: ${order.statusPemesanan}\nJumlah item: ${order.jumlahItem}",
                    style: TextStyle(
                      fontSize: 12,
                      color: expired
                          ? Colors.red
                          : waiting
                              ? Colors.orange
                              : Colors.grey[700],
                    ),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
                 onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HistoryPage(idCheckout: order.idCheckout), // ⬅️ passing list
                        ),
                      );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
