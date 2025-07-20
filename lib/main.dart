import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/services/auth/session_service.dart';
import 'package:agrix_beta_2025/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔐 Check if a valid session + biometric access is available
  final bool isAuthenticated = await SessionService.checkSession();

  runApp(AgriXApp(isAuthenticated: isAuthenticated));
}

class AgriXApp extends StatelessWidget {
  final bool isAuthenticated;

  const AgriXApp({super.key, required this.isAuthenticated});

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
      home: isAuthenticated ? const LandingPage() : const AuthGate(),
      routes: appRoutes,
    );
  }
}
