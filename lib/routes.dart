import 'package:flutter/material.dart';
import 'screens/profile/farmer_profile_screen.dart';
import 'screens/profile/edit_farmer_profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/profile': (context) => const FarmerProfileScreen(),
  '/profile/edit': (context) => const EditFarmerProfileScreen(),
};
