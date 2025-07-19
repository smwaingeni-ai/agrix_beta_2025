import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';
// Add others as implemented
import 'package:agrix_beta_2025/screens/market/market_screen.dart';
import 'package:agrix_beta_2025/screens/loans/loan_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/profile': (context) => const FarmerProfileScreen(),
  '/profile/edit': (context) => const EditFarmerProfileScreen(),
  '/market': (context) => const MarketScreen(),
  '/loan': (context) => const LoanScreen(),
  // Add others once available
};
