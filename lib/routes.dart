import 'package:flutter/material.dart';

// Core Screens
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';

// Auth Screens
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// Farmer Profile Screens
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const AuthGate(),
  '/auth': (context) => const AuthGate(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterUserScreen(),
  '/landing': (context) => const LandingPage(),
  '/profile': (context) => const FarmerProfileScreen(),
  '/profile/edit': (context) => const EditFarmerProfileScreen(),
};
