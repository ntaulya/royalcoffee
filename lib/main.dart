import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royalcoffee/admin/screens/Customer.dart';
import 'package:royalcoffee/admin/screens/IncomingOrder.dart';
import 'package:royalcoffee/admin/screens/Menu.dart';
import 'package:royalcoffee/admin/screens/TrackOrder.dart';
import 'package:royalcoffee/controllers/product/ProductController.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Royal Cafe',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Poppins',
      ),
      home: const IncomingOrder(), // ganti ke halaman pertama kamu
    );
  }
}
