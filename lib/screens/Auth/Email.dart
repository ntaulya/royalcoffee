import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Logo dan Judul
            Text(
              "Royal Cafe",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/Banner.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Enjoy!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                    ),
                  ),
                  const Text(
                    "For your first order",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Semoga Hari Anda Selalu Menjadi Menyenangkan!",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hi,",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Berikut adalah kode OTP (One Time Password) Anda.\n"
              "Silakan masukkan kode ini untuk memverifikasi alamat email Anda untuk Royal Cafe:",
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),

            // Kode OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final otpDigits = ["5", "7", "2", "0"];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: size.width * 0.15,
                  height: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    otpDigits[index],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            const Text(
              "Kode OTP ini akan kedaluwarsa dalam waktu 5 menit.\n"
              "Jika Anda merasa tidak pernah meminta kode OTP, silakan abaikan email ini.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            const Text(
              "Salam hangat,\nRoyal Cafe.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Footer
            Column(
              children: [
                const Icon(Icons.camera_alt_outlined, color: Colors.brown),
                const SizedBox(height: 10),
                Text(
                  "Anda menerima email ini karena telah mendaftar di platform Royal Cafe...",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("Privacy policy",
                          style: TextStyle(fontSize: 10)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Terms of service",
                          style: TextStyle(fontSize: 10)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Help center",
                          style: TextStyle(fontSize: 10)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Unsubscribe",
                          style: TextStyle(fontSize: 10)),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
