// lib/routes.dart

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

// ✅ Training Logs
import 'package:agrix_beta_2025/screens/training/training_log_screen.dart';

// ✅ Notifications
import 'package:agrix_beta_2025/screens/notifications/notifications_screen.dart';

// ✅ Chat & Help
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

// ✅ Sustainability
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // Core
  '/': (context) => const AuthGate(),
  'landing': (context) => const LandingPage(),

  // Auth
  'login': (context) => const LoginScreen(),
  'register': (context) => const RegisterUserScreen(),

  // Farmer Profile
  'farmerProfile': (context) => const FarmerProfileScreen(),
  'editFarmerProfile': (context) => const EditFarmerProfileScreen(),

  // Loans
  'loan': (context) => const LoanScreen(),
  'loanApplication': (context) => const LoanApplicationScreen(),
  'loanList': (context) => const LoanListScreen(),

  // Training
  'trainingLog': (context) => const TrainingLogScreen(),

  // Notifications
  'notifications': (context) => const NotificationsScreen(),

  // Chat & Help
  'chat': (context) => const ChatScreen(),
  'help': (context) => const HelpScreen(),

  // Sustainability
  'sustainabilityLog': (context) => const SustainabilityLogScreen(),
};
