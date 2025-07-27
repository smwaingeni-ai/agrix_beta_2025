import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 🧠 Session Management
import 'package:agrix_beta_2025/services/auth/session_service.dart';

// 🗺️ App Routes
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
