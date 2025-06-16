import 'package:flutter/material.dart';
import 'package:royalcoffee/admin/screens/EditMenu.dart';
import 'package:royalcoffee/models/Profile.dart';
import 'package:royalcoffee/screens/Auth/User/ProfilePage.dart';
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
      home: EditMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}