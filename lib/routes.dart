// lib/routes.dart

import 'package:flutter/material.dart';

// Core Screens
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/sync_screen.dart';
import 'package:agrix_beta_2025/screens/core/notifications_screen.dart';

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

// Contracts
import 'package:agrix_beta_2025/screens/contracts/contract_list_screen.dart';

// Investments
import 'package:agrix_beta_2025/screens/investments/investor_list_screen.dart';

// Logs
import 'package:agrix_beta_2025/screens/logs/logbook_screen.dart';
import 'package:agrix_beta_2025/screens/programs/program_tracking_screen.dart';
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';
import 'package:agrix_beta_2025/screens/training/training_log_screen.dart';

// Diagnostics & AI
import 'package:agrix_beta_2025/screens/diagnostics/diagnostics_landing_screen.dart';
import 'package:agrix_beta_2025/screens/ai_advice/agrigpt_screen.dart';

// Chat and Help
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // Initial gate
  '/': (context) => const AuthGate(),

  // Core
  'landing': (context) => const LandingPage(),
  'sync': (context) => const SyncScreen(),
  'notifications': (context) => const NotificationsScreen(),

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

  // Contracts
  'contracts': (context) => const ContractListScreen(),

  // Investments
  'investments': (context) => const InvestorListScreen(),

  // Logs
  'logbook': (context) => const LogbookScreen(),
  'programTracking': (context) => const ProgramTrackingScreen(),
  'sustainabilityLog': (context) => const SustainabilityLogScreen(),
  'trainingLog': (context) => const TrainingLogScreen(),

  // Diagnostics & AI
  'diagnostics': (context) => const DiagnosticsLandingScreen(),
  'agrigpt': (context) => const AgriGPTScreen(),

  // Chat & Help
  'chat': (context) => const ChatScreen(),
  'help': (context) => const HelpScreen(),
};
