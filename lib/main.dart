import 'package:flutter/material.dart';
import 'package:royalcoffee/admin/home/DashboardAdmin.dart';
import 'package:royalcoffee/admin/screens/AddMenu.dart';
import 'package:royalcoffee/admin/screens/EditMenu.dart';
import 'package:royalcoffee/admin/screens/Menu.dart';
import 'screens/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Cafe',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}