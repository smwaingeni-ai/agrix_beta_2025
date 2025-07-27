import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';
import 'package:agrix_beta_2025/screens/profile/farmer_profile_form.dart';
import 'package:agrix_beta_2025/screens/investments/investor_registration_screen.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Fields
  String role = 'Farmer';
  String name = '';
  String passcode = '';
  String phone = '';
  String idNumber = '';
  String region = '';
  String province = '';
  String district = '';
  String ward = '';
  String village = '';
  String cell = '';
  String farmType = '';

  final List<String> roles = ['Farmer', 'Investor', 'AREX Officer', 'Government Official', 'Admin'];

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final user = UserModel(id: userId, role: role, name: name, passcode: passcode);

    await _saveUserToFile(user);

    // Redirect based on role
    if (role == 'Investor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => InvestorRegistrationScreen(userId: userId, name: name)),
      );
    } else if (role == 'Farmer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FarmerProfileForm(userId: userId, name: name)),
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ User registered successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _saveUserToFile(UserModel user) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/registered_users.json');
      List<dynamic> users = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          users = jsonDecode(content);
        }
      }

      users.add(user.toJson());
      await file.writeAsString(jsonEncode(users));
    } catch (e) {
      debugPrint('❌ Error saving user: $e');
    }
  }

  Widget _buildTextField({
    required String label,
    bool obscure = false,
    bool validator = false,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator ? (val) => val == null || val.isEmpty ? 'Required' : null : null,
        onSaved: onSaved,
      ),
    );
  }

  List<Widget> _buildFarmerFields() {
    return [
      _buildTextField(
        label: 'ID Number',
        onSaved: (val) => idNumber = val!,
        validator: true,
      ),
      _buildTextField(
        label: 'Phone Number',
        keyboardType: TextInputType.phone,
        onSaved: (val) => phone = val!,
        validator: true,
      ),
      _buildTextField(label: 'Province', onSaved: (val) => province = val ?? ''),
      _buildTextField(label: 'District', onSaved: (val) => district = val ?? ''),
      _buildTextField(label: 'Ward', onSaved: (val) => ward = val ?? ''),
      _buildTextField(label: 'Village', onSaved: (val) => village = val ?? ''),
      _buildTextField(label: 'Cell', onSaved: (val) => cell = val ?? ''),
      _buildTextField(label: 'Farm Type (e.g. Crops, Livestock)', onSaved: (val) => farmType = val ?? ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register New User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Role'),
                value: role,
                items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) => setState(() => role = val!),
              ),
              _buildTextField(
                label: 'Username / Full Name',
                onSaved: (val) => name = val!,
                validator: true,
              ),
              if (role == 'Farmer') ..._buildFarmerFields(),
              _buildTextField(
                label: 'Passcode',
                obscure: true,
                onSaved: (val) => passcode = val!,
                validator: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Register'),
                onPressed: _registerUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
