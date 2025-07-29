import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';
import 'package:agrix_beta_2025/services/auth/session_service.dart';

import 'auth_gate.dart';

class LandingPage extends StatefulWidget {
  final FarmerProfile? farmer;

  const LandingPage({super.key, this.farmer});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FarmerProfile? _profile;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loaded = widget.farmer ?? await FarmerProfileService.loadActiveProfile();
    final user = await SessionService.loadActiveUser();
    if (mounted) {
      setState(() {
        _profile = loaded;
        _user = user;
      });
      debugPrint("✅ Loaded role: ${user?.role}");
    }
  }

  Future<void> _deleteProfile() async {
    await FarmerProfileService.clearActiveProfile();
    if (mounted) setState(() => _profile = null);
  }

  Future<void> _logout() async {
    await SessionService.clearSession();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    }
  }

  void _shareProfile() {
    if (_profile == null) return;
    final data = '''
👤 Name: ${_profile!.fullName}
🆔 ID: ${_profile!.idNumber}
📞 Phone: ${_profile!.contactNumber}
📐 Size: ${_profile!.farmSizeHectares ?? 'N/A'} ha
📍 Region: ${_profile!.region ?? 'N/A'}
🏛️ Subsidised: ${_profile!.subsidised ? 'Yes' : 'No'}
''';
    Share.share(data);
  }

  Widget _buildGridButton(String label, String route, IconData icon) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green[800],
          padding: const EdgeInsets.all(12),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildModuleRow(List<Map<String, dynamic>> modules) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: modules
            .map((btn) => _buildGridButton(
                  btn['label'] as String,
                  btn['route'] as String,
                  btn['icon'] as IconData,
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFarmer = _user?.role.trim().toLowerCase().contains('farmer') ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriX Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/alogo.png', height: 100),
            const SizedBox(height: 12),
            _profile != null
                ? Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.green.shade100,
                            backgroundImage: (!kIsWeb &&
                                    _profile!.photoPath != null &&
                                    File(_profile!.photoPath!).existsSync())
                                ? FileImage(File(_profile!.photoPath!))
                                : null,
                            child: (_profile!.photoPath == null ||
                                    !File(_profile!.photoPath!).existsSync())
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                        ),
                        ListTile(
                          title: Text(_profile!.fullName),
                          subtitle: Text(
                              '${_profile!.region ?? "N/A"} • ${_profile!.farmSizeHectares ?? "N/A"} ha'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Profile'),
                                onPressed: () => Navigator.pushNamed(context, '/editFarmerProfile'),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                                onPressed: _shareProfile,
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _deleteProfile,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Create Farmer Profile'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/farmerProfile').then((_) => _loadProfile());
                    },
                  ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isFarmer
                      ? [
                          _buildSectionHeader('💳 Credit Tools'),
                          _buildModuleRow([
                            {'label': 'Credit Score', 'route': '/creditScore', 'icon': Icons.score},
                            {'label': 'Apply for Loan', 'route': '/loanApplication', 'icon': Icons.assignment},
                            {'label': 'View Loans', 'route': '/loan', 'icon': Icons.account_balance},
                          ]),
                          _buildSectionHeader('🌾 Diagnostics'),
                          _buildModuleRow([
                            {'label': 'Crop Diagnosis', 'route': '/crops', 'icon': Icons.eco},
                            {'label': 'Livestock Diagnosis', 'route': '/livestock', 'icon': Icons.pets},
                          ]),
                          _buildSectionHeader('🎓 Training'),
                          _buildModuleRow([
                            {'label': 'Training Log', 'route': '/trainingLog', 'icon': Icons.school},
                            {'label': 'View Training', 'route': '/training/view', 'icon': Icons.menu_book},
                          ]),
                          _buildSectionHeader('🛒 Trade & Market'),
                          _buildModuleRow([
                            {'label': 'Trade', 'route': '/market', 'icon': Icons.store},
                            {'label': 'Marketplace', 'route': '/market/listings', 'icon': Icons.shopping_cart},
                          ]),
                          _buildSectionHeader('💬 General'),
                          _buildModuleRow([
                            {'label': 'Notifications', 'route': '/notifications', 'icon': Icons.notifications},
                            {'label': 'Help', 'route': '/help', 'icon': Icons.help_outline},
                            {'label': 'Chat', 'route': '/chat', 'icon': Icons.chat},
                          ]),
                        ]
                      : [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'No role-specific layout yet for this role.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
