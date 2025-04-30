import 'package:flutter/material.dart';
import '../controllers/reset_pass_controller.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key, this.title = 'Reset Password'});
  final String title;

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final ResetPassController _controller = ResetPassController();

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
              
              const Text(
                'Atur Password Baru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 20),

              TextField(
                controller: _controller.newPasswordController,
                obscureText: _controller.obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Masukkan Password Baru',
                  hintText: 'Masukkan password baru Anda',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_controller.obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _controller.togglePasswordVisibility();
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _controller.confirmPasswordController,
                obscureText: _controller.obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Masukkan Ulang Password Baru',
                  hintText: 'Masukkan ulang password baru Anda',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_controller.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _controller.toggleConfirmPasswordVisibility();
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  // Panggil method resetPassword dari controller
                  final bool success = await _controller.resetPassword(context);
                  
                  if (success) {
                    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
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
                  'Atur Password',
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