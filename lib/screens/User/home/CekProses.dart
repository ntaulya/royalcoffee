import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../layout/BottomNavBar.dart';

class CekProses extends StatelessWidget {
  const CekProses({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF7A491F), // <<< status bar warna cokelat
        statusBarIconBrightness: Brightness.light, // icon jadi putih
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Latar belakang backup
            Container(color: Colors.white),

            // Konten
            Column(
              children: [
                // =========== HEADER ===========
                Container(
                  width: double.infinity,
                  color: const Color(0xFF7A491F),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12, // tambah padding top agar tidak nabrak notch
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Cek Antrian & Proses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // =========== KONTEN ===========
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAntrianItem(
                            nomor: '1',
                            nama: 'Andi Syaifullah',
                            status: 'proses',
                          ),
                          const SizedBox(height: 20),
                          _buildAntrianItem(
                            nomor: '2',
                            nama: 'Dewi Sartika',
                            status: 'selesai',
                          ),
                          const SizedBox(height: 20),
                          _buildAntrianItem(
                            nomor: '3',
                            nama: 'Rahmat Hidayat',
                            status: 'menunggu',
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // =========== BOTTOM NAVBAR ===========
            const Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavBar(selectedIndex: 1),
            ),
          ],
        ),
      ),
    );
  }

  // =========== ITEM ANTRIAN ===========
  static Widget _buildAntrianItem({
    required String nomor,
    required String nama,
    required String status,
  }) {
    Color getColor(String step) =>
        (status == step) ? const Color(0xFF7A491F) : const Color(0xFFE0DFDF);

    Color getTextColor(String step) =>
        (status == step) ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF4C2609),
                child: Text(
                  nomor,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: ['menunggu', 'proses', 'selesai'].map((step) {
              return Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: getColor(step),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      step == 'menunggu' ? 'Menunggu diproses' : step.capitalize(),
                      style: TextStyle(
                        fontSize: 12,
                        color: getTextColor(step),
                      ),
                    ),
                  ),
                  if (step != 'selesai')
                    const Icon(Icons.arrow_right_alt, size: 18, color: Colors.black45),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// =========== EXTENSION UTK CAPITALIZE ===========
extension CapExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
