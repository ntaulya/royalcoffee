import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/otp_controller.dart';
import 'reset_pass.dart';

class Otp extends StatefulWidget {
  const Otp({super.key, this.title = 'OTP'});
  final String title;

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final AuthController _authController = AuthController();
  final OtpController _otpController = OtpController();

  @override
  void dispose() {
    _authController.dispose();
    _otpController.dispose();
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

              const Text(
                'Masukkan Kode OTP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _otpController.otpControllers[index],
                      focusNode: _otpController.focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (value) => _otpController.onOtpChanged(
                        index: index,
                        value: value,
                        context: context,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    // Implementasi logika kirim ulang OTP
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kode OTP dikirim ulang')),
                    );
                  },
                  child: const Text(
                    'Tidak menerima kode? Kirim ulang',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF834D1E),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  final otpCode = _otpController.otpCode;

                  // Verifikasi OTP dan jika berhasil, navigasi ke halaman reset password
                  if (_authController.verifyOtp(context, otpCode)) {
                    // Navigasi ke halaman reset password
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPass()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF834D1E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Verifikasi OTP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}