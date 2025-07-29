import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/services/auth/biometric_auth_service.dart';

// Dummy users for testing – replace with real auth backend
final List<UserModel> dummyUsers = [
  UserModel(id: '1', name: 'John', role: 'Farmer', passcode: '1234'),
  UserModel(id: '2', name: 'Alice', role: 'Trader', passcode: '5678'),
  UserModel(id: '3', name: 'AdminUser', role: 'Admin', passcode: 'admin'),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedRole = 'Farmer';
  String name = '';
  String passcode = '';
  bool _obscureText = true;

  final List<String> roles = [
    'Farmer',
    'AREX Officer',
    'Government Official',
    'Admin',
    'Trader',
    'Investor',
  ];

  void _validateLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = dummyUsers.firstWhere(
        (u) =>
            u.name.toLowerCase() == name.trim().toLowerCase() &&
            u.passcode == passcode &&
            u.role == selectedRole,
        orElse: () => UserModel(id: '', name: '', role: '', passcode: ''),
      );

      if (user.id.isNotEmpty) {
        _navigateToRoleScreen(user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Invalid credentials')),
        );
      }
    }
  }

  void _navigateToRoleScreen(UserModel user) {
    final role = user.role;
    if (role == 'Farmer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LandingPage(farmer: FarmerProfile.fromUser(user)),
        ),
      );
    } else {
      final routeMap = {
        'AREX Officer': '/officerDashboard',
        'Government Official': '/officialDashboard',
        'Admin': '/adminPanel',
        'Trader': '/traderDashboard',
        'Investor': '/investorDashboard',
      };
      final route = routeMap[role];
      if (route != null) {
        Navigator.pushReplacementNamed(context, route, arguments: user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Unknown role. Contact admin.')),
        );
      }
    }
  }

  Future<void> _loginWithBiometrics() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Biometrics not supported on Web')),
      );
      return;
    }

    final success = await BiometricAuthService.authenticate();
    if (success) {
      final user = dummyUsers.firstWhere(
        (u) => u.role == 'Farmer',
        orElse: () => UserModel(id: '', name: '', role: '', passcode: ''),
      );

      if (user.id.isNotEmpty) {
        _navigateToRoleScreen(user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ No Farmer profile found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Biometric auth failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/alogo.png', height: 32),
            const SizedBox(width: 8),
            const Text('AgriX Login'),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '🔐 Login to AgriX',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select Role'),
                  value: selectedRole,
                  items: roles
                      .map((role) => DropdownMenuItem(
                          value: role, child: Text(role)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Required' : null,
                  onSaved: (value) => name = value!.trim(),
                ),

                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Passcode',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => passcode = value!,
                ),

                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  onPressed: _validateLogin,
                ),

                if (!kIsWeb && selectedRole == 'Farmer') ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Login with Biometrics'),
                    onPressed: _loginWithBiometrics,
                  ),
                ],

                const SizedBox(height: 20),
                TextButton.icon(
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Create New Account'),
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
