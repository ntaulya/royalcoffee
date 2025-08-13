import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Pesanan Dikonfirmasi",
        "message": "Pesanan #1234 Anda telah dikonfirmasi dan sedang diproses.",
        "time": "2 menit lalu",
        "icon": Icons.check_circle
      },
      {
        "title": "Promo Spesial",
        "message": "Diskon 20% untuk semua minuman hari ini!",
        "time": "1 jam lalu",
        "icon": Icons.local_offer
      },
      {
        "title": "Pesanan Selesai",
        "message": "Pesanan #1228 Anda sudah siap diambil.",
        "time": "Kemarin",
        "icon": Icons.coffee
      },
    ];

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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown[100],
                  child: Icon(
                    notif["icon"] as IconData,
                    color: Colors.brown[700],
                  ),
                ),
                title: Text(notif["title"] as String),
                subtitle: Text(
                  "${notif["message"]}\n${notif["time"]}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                isThreeLine: true,
              ),
          );
        },
      ),
    );
  }
}
