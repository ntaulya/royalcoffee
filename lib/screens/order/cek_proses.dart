import 'package:flutter/material.dart';

class CekAntrianPage extends StatelessWidget {
  const CekAntrianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7A491F),
      bottomNavigationBar: _buildBottomBar(),
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cek Antrian & Proses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Container putih isi konten
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAntrianItem(
                    nomor: '1',
                    nama: 'AndiSyaifullah',
                    status: 'proses',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAntrianItem({
    required String nomor,
    required String nama,
    required String status,
  }) {
    Color getColor(String step) {
      if (status == step) {
        return const Color(0xFF7A491F);
      } else {
        return const Color(0xFFE0DFDF);
      }
    }

    Color getTextColor(String step) {
      return (status == step) ? Colors.white : Colors.black;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
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
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 20),
        // Step indicators
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getColor('menunggu'),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Menunggu diproses',
            style: TextStyle(
              fontSize: 12,
              color: getTextColor('menunggu'),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_right_alt, color: Colors.black54),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getColor('proses'),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Proses',
            style: TextStyle(
              fontSize: 12,
              color: getTextColor('proses'),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_right_alt, color: Colors.black54),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getColor('selesai'),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Selesai',
            style: TextStyle(
              fontSize: 12,
              color: getTextColor('selesai'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {},
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: _buildBadge('2'),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.credit_card_outlined),
              onPressed: () {},
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: _buildBadge('1'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String count) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        count,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
