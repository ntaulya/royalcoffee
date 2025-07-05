import 'package:flutter/material.dart';
import 'dart:async';
import '../../controllers/AuthController.dart';
import '../../controllers/otp_controller.dart';
import 'ResetPass.dart';

class Otp extends StatefulWidget {
  final String email;
  final String title;

  const Otp({
    super.key,
    required this.email,
    this.title = 'OTP',
  });

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final AuthController _authController = AuthController();
  final OtpController _otpController = OtpController();


  int _secondsRemaining = 300;
  late Timer _timer;
  bool _canResend = false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _authController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    _secondsRemaining = 300;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
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
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
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
                  onPressed: _canResend
                      ? () {
                          startTimer(); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kode OTP dikirim ulang')),
                          );
                        }
                      : null, 
                  child: Text(
                    _canResend
                        ? 'Tidak menerima kode? Kirim ulang'
                        : 'Kirim ulang dalam ${formatTime(_secondsRemaining)}',
                    style: const TextStyle(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPass(
                        email: widget.email,
                        otp: otpCode,
                        remainingTime: _secondsRemaining,
                      ),
                    ),
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