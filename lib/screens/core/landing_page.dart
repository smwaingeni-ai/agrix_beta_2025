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

    debugPrint("✅ Loaded user role: ${user?.role}");

    if (mounted) {
      setState(() {
        _profile = loaded;
        _user = user;
      });
    }
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

  Future<void> _deleteProfile() async {
    await FarmerProfileService.clearActiveProfile();
    if (mounted) setState(() => _profile = null);
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
      height: 100,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green[900],
          elevation: 2,
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleRow(List<Map<String, dynamic>> modules) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  List<Widget> _buildModulesForFarmer() {
    return [
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
      _buildSectionHeader('🛒 Market'),
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    final normalizedRole = _user?.role.toLowerCase().trim() ?? '';
    final isFarmer = normalizedRole.contains('farmer');

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
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Image.asset('assets/alogo.png', height: 90),
            const SizedBox(height: 10),
            _profile != null
                ? Card(
                    color: Colors.green.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.green.shade100,
                          backgroundImage: (!kIsWeb &&
                                  _profile!.photoPath != null &&
                                  File(_profile!.photoPath!).existsSync())
                              ? FileImage(File(_profile!.photoPath!))
                              : null,
                          child: (_profile!.photoPath == null ||
                                  !File(_profile!.photoPath!).existsSync())
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        ListTile(
                          title: Text(_profile!.fullName),
                          subtitle: Text('${_profile!.region ?? "N/A"} • ${_profile!.farmSizeHectares ?? "N/A"} ha'),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/editFarmerProfile'),
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Profile'),
                            ),
                            ElevatedButton.icon(
                              onPressed: _shareProfile,
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                            ),
                            ElevatedButton.icon(
                              onPressed: _deleteProfile,
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
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
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isFarmer
                      ? _buildModulesForFarmer()
                      : [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
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
