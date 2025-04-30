import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'otp.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key, this.title = 'Lupa Password'});
  final String title;

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final AuthController _controller = AuthController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/icons/royalcafeicon.png', height: 100),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/royalcafetext.png', height: 48),
                    const SizedBox(height: 10),
                    const Text(
                      'Selamat Datang, Semoga Hari Anda Menyenangkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF834D1E)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _controller.loginEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Enter Your Email Address',
                  hintText: 'Masukkan email Anda',
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '* Kami akan mengirimkan code OTP kepada Anda untuk mengatur atau mereset kata sandi baru Anda',
                style: TextStyle(fontSize: 14, color: Color(0xFF834D1E)),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Otp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF834D1E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Kirim Kode ke Email',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
