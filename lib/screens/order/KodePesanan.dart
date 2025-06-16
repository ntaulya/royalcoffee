import 'package:flutter/material.dart';

class KodePesanan extends StatelessWidget {
  final String kodePesanan = "5720";

  KodePesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_filled_rounded,
              size: 100,
              color: Color(0xFF4D2C12),
            ),
            const SizedBox(height: 16),

            const Text(
              'Terima Kasih',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              child: Text(
                'Konfirmasi pembayaran jika tidak dilakukan dalam 30 menit maka pesanan dihapus.\nSilahkan ke kasir untuk melakukan pembayaran!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),

            const SizedBox(height: 24),
            
            const Text('Kode Pesanan:', style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: kodePesanan.split('').map((digit) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    digit,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D2C12),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Kembali'),
            )
          ],
        ),
      ),
    );
  }
}
