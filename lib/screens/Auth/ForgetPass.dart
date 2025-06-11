import 'package:flutter/material.dart';
import 'otp.dart'; // Import halaman OTP kamu

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Disini bisa kamu kirim OTP ke email dulu (kalau mau)
                // Setelah itu, langsung navigasi ke halaman OTP
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Otp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF834D1E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Kirim OTP', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
