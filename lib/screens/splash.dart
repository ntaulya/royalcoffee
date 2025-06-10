import 'package:flutter/material.dart';
import '../services/SecureStorageService.dart';
import './home/home-coffee.dart';
import 'auth.dart'; // file MyRegister ada di auth.dart

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final SecureStorageService _storageService = SecureStorageService();


  Future<void> _checkToken() async{
    final token = await _storageService.getToken();
    
  
    if(token != null){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyRegister(title: '')),
      );
    }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyRegister(title: '')),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
       _checkToken();
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
