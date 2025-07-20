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

// 💡 Extend here for more screens as needed:
// import 'package:agrix_beta_2025/screens/loans/loan_screen.dart';
// import 'package:agrix_beta_2025/screens/contracts/contract_offer_form.dart';
// import 'package:agrix_beta_2025/screens/diagnostics/crops_screen.dart';
// import 'package:agrix_beta_2025/screens/ai_advice/agrigpt_screen.dart';
// import 'package:agrix_beta_2025/screens/market/market_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // Initial route
  '/': (context) => const AuthGate(),

  // Core and Auth
  '/auth': (context) => const AuthGate(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterUserScreen(),
  '/landing': (context) => const LandingPage(),

  // Farmer Profile
  '/profile': (context) => const FarmerProfileScreen(),
  '/profile/edit': (context) => const EditFarmerProfileScreen(),

  // 🔜 Activate when ready:
  // '/loan': (context) => const LoanScreen(),
  // '/contract/new': (context) => const ContractOfferForm(),
  // '/diagnostics/crops': (context) => const CropsScreen(),
  // '/agrigpt': (context) => const AgriGPTScreen(),
  // '/market': (context) => const MarketScreen(),
};
