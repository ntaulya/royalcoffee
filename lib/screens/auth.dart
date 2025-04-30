import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'forget_pass.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key, required this.title});
  final String title;

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final AuthController _controller = AuthController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/icons/royalcafeicon.png', height: 107),
              const SizedBox(height: 10),
              Image.asset('assets/images/royalcafetext.png', height: 48),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang, Semoga Hari Anda Menyenangkan',
                style: TextStyle(fontSize: 14, color: Color(0xFF834D1E)),
              ),

              const SizedBox(height: 20),

              const TabBar(
                labelColor: Color(0xFF834D1E),
                unselectedLabelColor: Colors.grey,
                tabs: [Tab(text: 'Login'), Tab(text: 'Sign-Up')],
              ),
              
              Expanded(
                child: TabBarView(
                  children: [
                    // Login UI
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _controller.loginEmailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'Masukkan Email',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _controller.loginPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Masukkan Password',
                              border: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ForgetPass()),
                              );
                            },
                            child: const Text(
                              'Forgot passcode?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF834D1E),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () => _controller.login(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF834D1E),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Register UI
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _controller.registerEmailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Masukkan Email',
                              border: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: _controller.registerPhoneController,
                            decoration: const InputDecoration(
                              labelText: 'Nomor Telepon',
                              hintText: 'Masukkan Nomor Telepon',
                              border: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: _controller.registerUsernameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              hintText: 'Masukkan Nama',
                              border: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),
                          TextField(
                            controller: _controller.registerPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Masukkan Password',
                              border: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),
                          TextField(
                            controller: _controller.registerConfirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Masukkan Konfirmasi Password',
                              border: UnderlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () => _controller.register(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF834D1E),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Sign-up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
