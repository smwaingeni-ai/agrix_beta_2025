import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/screens/auth/login_screen.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/services/auth/session_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      bool sessionExists;

      // ✅ Avoid biometric checks on Web
      if (kIsWeb) {
        sessionExists = await SessionService.isUserLoggedIn();
        debugPrint('ℹ️ Web: Session check skipped biometric auth');
      } else {
        sessionExists = await SessionService.checkSession();
        debugPrint('ℹ️ Mobile/Desktop: Full session + biometric check done');
      }

      setState(() {
        _isLoggedIn = sessionExists;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('⚠️ Session check failed: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _isLoggedIn ? const LandingPage() : const LoginScreen();
  }
}
