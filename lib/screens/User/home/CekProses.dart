import 'package:flutter/material.dart';
import '../../../services/Api/Antrian/AntrianService.dart';
import '../../../models/Antrian/Antrian.dart';
import '../layout/BottomNavBar.dart';

class CekProses extends StatefulWidget {
  const CekProses({super.key});

  @override
  State<CekProses> createState() => _CekProsesState();
}

class _CekProsesState extends State<CekProses> {
  final AntrianService _antrianService = AntrianService();
  List<Antrian> _antreanList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAntrean();
  }

  Future<void> _loadAntrean() async {
    try {
      final data = await _antrianService.getAntreanList();
      setState(() {
        _antreanList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF7A491F),
      body: Stack(
        children: [
          Column(
            children: [
              // HEADER
              SafeArea(
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFF7A491F),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
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
              ),

              // KONTEN PUTIH
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text('❌ $_error'))
                          : _antreanList.isEmpty
                              ? const Center(child: Text('Belum ada antrian'))
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                                  itemCount: _antreanList.length,
                                  itemBuilder: (context, index) {
                                    final item = _antreanList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: _buildAntrianItem(
                                        nomor: (index + 1).toString(),
                                        nama: item.namaUser,
                                        status: item.proces,
                                      ),
                                    );
                                  },
                                ),
                ),
              ),
            ],
          ),

          // BOTTOM NAVBAR
          const BottomNavBar(selectedIndex: 1),
        ],
      ),
    );
  }

  // ITEM ANTRIAN
  Widget _buildAntrianItem({
    required String nomor,
    required String nama,
    required String status,
  }) {
    // Mapping logika status
    String mapStatus(String status) {
      switch (status.toLowerCase()) {
        case 'dapur':
          return 'menunggu';
        case 'kasir':
          return 'proses';
        case 'selesai':
          return 'selesai';
        default:
          return status.toLowerCase();
      }
    }

    final mappedStatus = mapStatus(status);

    Color getColor(String step) =>
        (mappedStatus == step) ? const Color(0xFF7A491F) : const Color(0xFFE0DFDF);

    Color getTextColor(String step) =>
        (mappedStatus == step) ? Colors.white : Colors.black;

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
          // Nomor & Nama
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

          // Status
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

// EXTENSION: CAPITALIZE
extension CapExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
