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

// ✅ Loan Screens
import 'package:agrix_beta_2025/screens/loan/loan_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_application_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_list_screen.dart';

// ✅ Training Log Screens
import 'package:agrix_beta_2025/screens/training/training_log_screen.dart';

// ✅ Sustainability Screens
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';

// ✅ Notification Screens
import 'package:agrix_beta_2025/screens/notifications/notifications_screen.dart';

// ✅ Chat & Help Screens
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

// ✅ Services
import 'package:agrix_beta_2025/services/auth/session_service.dart';

// ✅ Models
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/models/loan/loan_application.dart';
import 'package:agrix_beta_2025/models/training/training_log.dart';
import 'package:agrix_beta_2025/models/sustainability/sustainability_log.dart';
import 'package:agrix_beta_2025/models/notifications/notification_message.dart';
import 'package:agrix_beta_2025/models/chat_help/chat_message.dart';

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
      routes: appRoutes, // ✅ All feature routes are centralized here
      home: isAuthenticated ? const LandingPage() : const AuthGate(),
    );
  }
}
