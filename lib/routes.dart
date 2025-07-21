// lib/routes.dart

import 'package:flutter/material.dart';

// Core Screens
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';

// Auth Screens
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// Farmer Profile Screens
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';

// Loan Screens
import 'package:agrix_beta_2025/screens/loan/loan_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_application_screen.dart';
import 'package:agrix_beta_2025/screens/loan/loan_list_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const AuthGate(),

  // Core Navigation
  'landing': (context) => const LandingPage(),

  // Auth Navigation
  'login': (context) => const LoginScreen(),
  'register': (context) => const RegisterUserScreen(),

  // Farmer Profile
  'farmerProfile': (context) => const FarmerProfileScreen(),
  'editFarmerProfile': (context) => const EditFarmerProfileScreen(),

  // Loans
  'loan': (context) => const LoanScreen(),
  'loanApplication': (context) => const LoanApplicationScreen(),
  'loanList': (context) => const LoanListScreen(),
};
