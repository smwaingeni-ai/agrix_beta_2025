import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 🧠 Session Management
import 'package:agrix_beta_2025/services/auth/session_service.dart';

// 🗺️ App Routes
import 'package:agrix_beta_2025/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final bool isAuthenticated = kIsWeb
        ? await SessionService.isUserLoggedIn()
        : await SessionService.checkSession();

    runApp(AgriXApp(isAuthenticated: isAuthenticated));
  } catch (e) {
    // Optional: Log to Crashlytics, Sentry, or debug console
    debugPrint('❌ Session check failed: $e');
    runApp(const AgriXApp(isAuthenticated: false));
  }
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
        useMaterial3: true, // ✅ Modern Material Design
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // ✅ Replace with your preferred font
      ),
      initialRoute: isAuthenticated ? '/' : '/login',
      routes: appRoutes,
    );
  }
}
