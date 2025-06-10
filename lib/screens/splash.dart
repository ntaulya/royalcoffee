import 'package:flutter/material.dart';
import '../controllers/AuthController.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final  AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
       _authController.checkToken(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF2D9),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/royalcafelogo.png', height: 107),
              Image.asset('assets/images/royalcafetext.png', height: 107),
            ],
          ),
        ),
      ),
    );
  }
}
