import 'package:flutter/material.dart';

class WaitersView extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'number': 1,
      'image': 'https://i.imgur.com/7GLW0Yt.png',
      'menu': 'Ice Cream Vanilla',
      'date': '29 Januari 2025',
      'time': '01:20 PM',
      'items': 2,
      'customer': 'Andi Syaifullah',
      'table': 'Meja 2',
      'type': '',
      'status': 'Menunggu Diproses',
      'button': 'Tandai Selesai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text(
          'Tampilan Khusus Waiters',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number Circle
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4B1D0D),
                      ),
                      child: Center(
                        child: Text(
                          order['number'].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        order['image'],
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Detail Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['menu'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${order['date']}, ${order['time']}, ${order['items']} Item, ${order['customer']}${order['table'] != '' ? ', ${order['table']}' : ''}${order['type'] != '' ? ', ${order['type']}' : ''}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Status Pesanan : ${order['status']}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B1D0D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: Text(order['button']),
                              ),
                              const SizedBox(width: 10),
                              
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(thickness: 0.7, indent: 16, endIndent: 16),
            ],
          );
        },
      ),
    );
  }
}
