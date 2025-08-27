import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/HistoryController.dart';
import '../../../models/LogHistory.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final HistoryController _controller = HistoryController();

  @override
  void initState() {
    super.initState();
    // Panggil API pas halaman dibuka
    _controller.getHistory();
  }

  String formatDate(DateTime date) {
    return DateFormat("dd MMM yyyy, HH:mm").format(date.toLocal());
  }

  bool isExpired(LogHistory notif) {
    final now = DateTime.now();
    final difference = now.difference(notif.createdAt);
    return notif.statusPemesanan.toLowerCase() == "detail" &&
        difference.inMinutes > 30;
  }

  bool isWaiting(LogHistory notif) {
    final now = DateTime.now();
    final difference = now.difference(notif.createdAt);
    return notif.statusPemesanan.toLowerCase() == "detail" &&
        difference.inMinutes <= 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        title: const Text(
          "Notifikasi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<LogHistory>>(
        stream: _controller.antrianStream,
        builder: (context, snapshot) {
          // ✅ Pastikan loading serentak, full screen
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada notifikasi"));
          }

          final notifications = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final expired = isExpired(notif);
              final waiting = isWaiting(notif);

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
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orange),
                                ),
                              )
                            : (notif.imagePath.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      notif.imagePath,
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
                    "Pesanan : ${formatDate(notif.createdAt)}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    expired
                        ? "Status: Expired\nJumlah item: ${notif.jumlahItem}"
                        : waiting
                            ? "Status: Menunggu\nJumlah item: ${notif.jumlahItem}"
                            : "Status: ${notif.statusPemesanan}\nJumlah item: ${notif.jumlahItem}",
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
