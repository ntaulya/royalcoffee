import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royalcoffee/screens/Splash.dart';
import 'package:royalcoffee/screens/WaitersView.dart';
import 'package:royalcoffee/admin/screens/AddMenu.dart';
import 'package:royalcoffee/admin/screens/ConfirmOrder.dart';
import 'package:royalcoffee/admin/screens/Customer.dart';
import 'package:royalcoffee/admin/screens/EditMenu.dart';
import 'package:royalcoffee/admin/screens/IncomingOrder.dart';
import 'package:royalcoffee/admin/screens/Menu.dart';
import 'package:royalcoffee/admin/screens/TrackOrder.dart';
import 'package:royalcoffee/admin/screens/AturMenu.dart';
import 'package:royalcoffee/screens/BaristaView.dart';
import 'package:royalcoffee/screens/WaitersView.dart';
import 'package:royalcoffee/controllers/product/ProductController.dart';
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