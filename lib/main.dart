import 'package:flutter/material.dart';

// ✅ Core Screens (must exist in lib/screens/core/)
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';

// ✅ Auth Screens (must exist in lib/screens/auth/)
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// ✅ Farmer Profile Screens (if needed)
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';

// ✅ Services (must be in lib/services/auth/)
import 'package:agrix_beta_2025/services/auth/session_service.dart';
import 'package:agrix_beta_2025/services/auth/biometric_auth_service.dart';
import 'package:agrix_beta_2025/services/auth/pin_auth_service.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';

// ✅ Models (optional for now in main.dart)
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/models/user_model.dart';

// ✅ Routing
import 'package:agrix_beta_2025/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Ensure session service is available and running
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
