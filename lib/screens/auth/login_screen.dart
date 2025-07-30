import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/services/auth/biometric_auth_service.dart';

// Dummy users for testing
final List<UserModel> dummyUsers = [
  UserModel(id: '1', name: 'John', role: 'farmer', passcode: '1234'),
  UserModel(id: '2', name: 'Alice', role: 'trader', passcode: '5678'),
  UserModel(id: '3', name: 'AdminUser', role: 'admin', passcode: 'admin'),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String selectedRole = 'farmer';
  String name = '';
  String passcode = '';

  final List<String> roles = [
    'farmer',
    'arex officer',
    'government official',
    'admin',
    'trader',
    'investor',
  ];

  void _validateLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = dummyUsers.firstWhere(
        (u) =>
            u.name.trim().toLowerCase() == name.trim().toLowerCase() &&
            u.passcode == passcode &&
            u.role.trim().toLowerCase() == selectedRole.trim().toLowerCase(),
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
    final role = user.role.trim().toLowerCase(); // ✅ Normalize role

    if (role == 'farmer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LandingPage(farmer: FarmerProfile.fromUser(user)),
        ),
      );
    } else {
      final routeMap = {
        'arex officer': '/officer/dashboard',
        'government official': '/official/dashboard',
        'admin': '/adminPanel',
        'trader': '/trader/dashboard',
        'investor': '/investors',
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
        (u) => u.role.trim().toLowerCase() == 'farmer',
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
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Image.asset('assets/alogo.png', height: 80),
                ),
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔐 Login to AgriX',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Select Role'),
                            value: selectedRole,
                            items: roles
                                .map((role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(role),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => selectedRole = value!),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Name'),
                            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            onSaved: (value) => name = value!.trim(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Passcode',
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => _obscureText = !_obscureText),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            onSaved: (value) => passcode = value!,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.login),
                            label: const Text('Login'),
                            onPressed: _validateLogin,
                            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                          ),
                          const SizedBox(height: 10),
                          if (!kIsWeb && selectedRole == 'farmer')
                            ElevatedButton.icon(
                              icon: const Icon(Icons.fingerprint),
                              label: const Text('Login with Biometrics'),
                              onPressed: _loginWithBiometrics,
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.person_add),
                                label: const Text('Create New Account'),
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                              ),
                              const Text('|', style: TextStyle(color: Colors.grey)),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('🔧 Forgot Password coming soon')),
                                  );
                                },
                                child: const Text('Forgot Password?'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
