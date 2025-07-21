import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ✅ Core Screens
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';

// ✅ Auth Screens
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// ✅ Farmer Profile Screens
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';

// ✅ Loan Screens (New)
import 'package:agrix_beta_2025/screens/loan/loan_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_application_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_list_screen.dart';

// ✅ Services
import 'package:agrix_beta_2025/services/auth/session_service.dart';

// ✅ Models
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/models/loan/loan_application.dart';

// ✅ Routes
import 'package:agrix_beta_2025/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Platform-safe session check
  final bool isAuthenticated = kIsWeb
      ? await SessionService.isUserLoggedIn()
      : await SessionService.checkSession();

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
      initialRoute: '/',
      routes: appRoutes, // ✅ Loan routes included here
      home: isAuthenticated ? const LandingPage() : const AuthGate(),
    );
  }
}
