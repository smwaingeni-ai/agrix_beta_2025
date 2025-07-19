import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/core/landing_page.dart';
import 'package:agrix_beta_2025/routes.dart';

void main() {
  runApp(const AgriXApp());
}

class AgriXApp extends StatelessWidget {
  const AgriXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriX Africa – ADT 2025',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LandingPage(),
      routes: appRoutes,
    );
  }
}
