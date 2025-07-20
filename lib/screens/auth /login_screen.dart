import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/services/biometric_auth_service.dart'; // 👈 Added

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
          builder: (_) => LandingPage(
            farmer: FarmerProfile.fromUser(user),
          ),
        ),
      );
    } else {
      final routeMap = {
        'AREX Officer': '/officer_dashboard',
        'Government Official': '/official_dashboard',
        'Admin': '/admin_panel',
        'Trader': '/trader_dashboard',
        'Investor': '/investor_dashboard',
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
    final success = await BiometricAuthService.authenticate();
    if (success) {
      // 👉 Log in first matching Farmer profile (for simplicity)
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
      appBar: AppBar(title: const Text('AgriX Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '🔐 Login to AgriX',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Role'),
                value: selectedRole,
                items: roles
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) => setState(() => selectedRole = value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => name = value!.trim(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Passcode'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => passcode = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Login'),
                onPressed: _validateLogin,
              ),
              const SizedBox(height: 10),
              if (selectedRole == 'Farmer') // 👈 Biometric only for Farmer
                ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Login with Biometrics'),
                  onPressed: _loginWithBiometrics,
                ),
              const SizedBox(height: 10),
              TextButton.icon(
                icon: const Icon(Icons.person_add_alt),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                label: const Text('Create New Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
