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
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Image.asset('assets/images/agrix_logo.png', height: 32),
          const SizedBox(width: 8),
          const Text('AgriX Login'),
        ],
      ),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.all(24),
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
                    const Text(
                      '🔐 Login to AgriX',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Role'),
                      value: selectedRole,
                      items: roles
                          .map((role) =>
                              DropdownMenuItem(value: role, child: Text(role)))
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
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Passcode',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      onSaved: (value) => passcode = value!,
                    ),

                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Login'),
                      onPressed: _validateLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Create New Account'),
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
