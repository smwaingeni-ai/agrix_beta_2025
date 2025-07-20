import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';
import 'package:agrix_beta_2025/screens/core/landing_page.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
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

  bool _submitted = false;
  FarmerProfile? _profile;

  final List<String> roles = ['Farmer', 'Officer', 'Official', 'Admin'];

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final user = UserModel(id: userId, role: role, name: name, passcode: passcode);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/registered_users.json');

    List<dynamic> users = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      if (contents.isNotEmpty) {
        users = jsonDecode(contents);
      }
    }

    users.add(user.toJson());
    await file.writeAsString(jsonEncode(users));

    if (role == 'Farmer') {
      _profile = FarmerProfile(
        farmerId: userId,
        fullName: name,
        contactNumber: phone,
        idNumber: idNumber,
        region: region,
        province: province,
        district: district,
        ward: ward,
        village: village,
        cell: cell,
        farmSizeHectares: 1.0,
        farmType: farmType,
        subsidised: true,
        govtAffiliated: false,
        language: 'English',
        createdAt: DateTime.now().toIso8601String(),
        qrImagePath: '',
        photoPath: null,
        farmLocation: '',
      );

      if (!kIsWeb) {
        await FarmerProfileService.saveActiveProfile(_profile!);
      }

      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Farmer registered successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LandingPage(farmer: _profile)),
      );
    } else {
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ User registered successfully')),
      );
    }
  }

  Widget _buildQRCode() {
    final encoded = jsonEncode(_profile?.toJson() ?? {});
    return QrImageView(
      data: encoded,
      version: QrVersions.auto,
      size: 220,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register New User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _submitted && role == 'Farmer'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉 Registration Complete!', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  const Text('📲 Scan this QR to identify the farmer:', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  _buildQRCode(),
                ],
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Role'),
                      value: role,
                      items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) => setState(() => role = val!),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username / Full Name'),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      onSaved: (val) => name = val!,
                    ),
                    if (role == 'Farmer') ...[
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'ID Number'),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        onSaved: (val) => idNumber = val!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        onSaved: (val) => phone = val!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Province'),
                        onSaved: (val) => province = val ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'District'),
                        onSaved: (val) => district = val ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Ward'),
                        onSaved: (val) => ward = val ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Village'),
                        onSaved: (val) => village = val ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Cell'),
                        onSaved: (val) => cell = val ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Farm Type (e.g. Crops, Livestock)'),
                        onSaved: (val) => farmType = val ?? '',
                      ),
                    ],
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Passcode'),
                      obscureText: true,
                      validator: (val) => val == null || val.length < 4 ? 'Min 4 digits' : null,
                      onSaved: (val) => passcode = val!,
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
