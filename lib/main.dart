import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ✅ Core Screens
import 'package:agrix_beta_2025/screens/core/auth_gate.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/core/notifications_screen.dart';
import 'package:agrix_beta_2025/screens/core/sync_screen.dart';

// ✅ Auth
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/auth/register_user_screen.dart';

// ✅ Diagnostics
import 'package:agrix_beta_2025/screens/diagnostics/upload_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/crops_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/livestock_screen.dart';
import 'package:agrix_beta_2025/screens/diagnostics/soil_screen.dart';

// ✅ Profile
import 'package:agrix_beta_2025/screens/profile/farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/edit_farmer_profile_screen.dart';
import 'package:agrix_beta_2025/screens/profile/credit_score_screen.dart';

// ✅ Loans
import 'package:agrix_beta_2025/screens/loans/loan_screen.dart';
import 'package:agrix_beta_2025/screens/loans/loan_application.dart';

// ✅ Logs
import 'package:agrix_beta_2025/screens/logs/logbook_screen.dart';
import 'package:agrix_beta_2025/screens/logs/training_log_screen.dart';
import 'package:agrix_beta_2025/screens/logs/sustainability_log_screen.dart';

// ✅ Market
import 'package:agrix_beta_2025/screens/market/market_screen.dart';

// ✅ Investments
import 'package:agrix_beta_2025/screens/investments/investor_list_screen.dart';

// ✅ Contracts
import 'package:agrix_beta_2025/screens/contracts/contract_list_screen.dart';

// ✅ Officers & Tasks
import 'package:agrix_beta_2025/screens/officers/officer_tasks_screen.dart';
import 'package:agrix_beta_2025/screens/tasks/task_entry_screen.dart';

// ✅ Programs
import 'package:agrix_beta_2025/screens/programs/program_tracking_screen.dart';

// ✅ Sustainability
import 'package:agrix_beta_2025/screens/sustainability/sustainability_log_screen.dart';

// ✅ Trader Dashboard
import 'package:agrix_beta_2025/screens/trader/trader_dashboard.dart';

// ✅ Help & Chat
import 'package:agrix_beta_2025/screens/chat_help/chat_screen.dart';
import 'package:agrix_beta_2025/screens/chat_help/help_screen.dart';

// ✅ Services
import 'package:agrix_beta_2025/services/auth/session_service.dart';

// ✅ App Routes
import 'package:agrix_beta_2025/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      initialRoute: isAuthenticated ? '/' : '/login',
      routes: appRoutes,
    );
  }
}
