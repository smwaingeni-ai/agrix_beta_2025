// lib/screens/core/landing_page.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';
import 'package:agrix_beta_2025/services/auth/session_service.dart';

import 'auth_gate.dart';
import 'package:agrix_beta_2025/models/user_model.dart';

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
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[800],
        padding: const EdgeInsets.all(12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getButtonsForRole(String? role) {
    final List<Map<String, dynamic>> common = [
      {'label': 'Notifications', 'route': '/notifications', 'icon': Icons.notifications},
      {'label': 'Help', 'route': '/help', 'icon': Icons.help_outline},
      {'label': 'Chat', 'route': '/chat', 'icon': Icons.chat},
    ];

    switch (role) {
      case 'Farmer':
        return [
          {'label': 'Edit Profile', 'route': '/editFarmerProfile', 'icon': Icons.edit},
          {'label': 'Loan Dashboard', 'route': '/loan', 'icon': Icons.account_balance},
          {'label': 'Apply for Loan', 'route': '/loanApplication', 'icon': Icons.assignment},
          {'label': 'Credit Score', 'route': '/creditScore', 'icon': Icons.score},
          {'label': 'Crop Diagnosis', 'route': '/crops', 'icon': Icons.eco},
          {'label': 'Soil Advisor', 'route': '/soil', 'icon': Icons.terrain},
          {'label': 'Livestock Diagnosis', 'route': '/livestock', 'icon': Icons.pets},
          {'label': 'Training Log', 'route': '/trainingLog', 'icon': Icons.school},
          {'label': 'Sustainability Log', 'route': '/sustainabilityLog', 'icon': Icons.nature},
          {'label': 'Logbook', 'route': '/logbook', 'icon': Icons.book},
          {'label': 'Market', 'route': '/market', 'icon': Icons.store},
          {'label': 'Contracts', 'route': '/contracts/list', 'icon': Icons.assignment_turned_in},
          ...common,
        ];
      case 'Investor':
        return [
          {'label': 'Investors', 'route': '/investors', 'icon': Icons.people},
          {'label': 'Contracts', 'route': '/contracts/list', 'icon': Icons.assignment_turned_in},
          ...common,
        ];
      case 'AREX Officer':
        return [
          {'label': 'Officer Tasks', 'route': '/officer/tasks', 'icon': Icons.task},
          {'label': 'Training Log', 'route': '/trainingLog', 'icon': Icons.school},
          {'label': 'Sustainability Log', 'route': '/sustainabilityLog', 'icon': Icons.nature},
          {'label': 'Logbook', 'route': '/logbook', 'icon': Icons.book},
          ...common,
        ];
      case 'Trader':
        return [
          {'label': 'Trader Dashboard', 'route': '/trader/dashboard', 'icon': Icons.dashboard},
          {'label': 'Market', 'route': '/market', 'icon': Icons.store},
          ...common,
        ];
      case 'Government Official':
        return [
          {'label': 'Official Dashboard', 'route': '/official/dashboard', 'icon': Icons.admin_panel_settings},
          {'label': 'Program Tracking', 'route': '/programTracking', 'icon': Icons.track_changes},
          {'label': 'Sustainability Log', 'route': '/sustainabilityLog', 'icon': Icons.nature},
          ...common,
        ];
      case 'Admin':
        return [
          {'label': 'Edit Profile', 'route': '/editFarmerProfile', 'icon': Icons.edit},
          {'label': 'Loan Dashboard', 'route': '/loan', 'icon': Icons.account_balance},
          {'label': 'Apply for Loan', 'route': '/loanApplication', 'icon': Icons.assignment},
          {'label': 'Credit Score', 'route': '/creditScore', 'icon': Icons.score},
          {'label': 'Crop Diagnosis', 'route': '/crops', 'icon': Icons.eco},
          {'label': 'Soil Advisor', 'route': '/soil', 'icon': Icons.terrain},
          {'label': 'Livestock Diagnosis', 'route': '/livestock', 'icon': Icons.pets},
          {'label': 'Training Log', 'route': '/trainingLog', 'icon': Icons.school},
          {'label': 'Sustainability Log', 'route': '/sustainabilityLog', 'icon': Icons.nature},
          {'label': 'Logbook', 'route': '/logbook', 'icon': Icons.book},
          {'label': 'Market', 'route': '/market', 'icon': Icons.store},
          {'label': 'Contracts', 'route': '/contracts/list', 'icon': Icons.assignment_turned_in},
          {'label': 'Investors', 'route': '/investors', 'icon': Icons.people},
          {'label': 'Officer Tasks', 'route': '/officer/tasks', 'icon': Icons.task},
          {'label': 'Trader Dashboard', 'route': '/trader/dashboard', 'icon': Icons.dashboard},
          {'label': 'Official Dashboard', 'route': '/official/dashboard', 'icon': Icons.admin_panel_settings},
          ...common,
        ];
      default:
        return common;
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = _user?.role ?? 'Guest';
    final buttons = _getButtonsForRole(role);

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
                        if (!kIsWeb &&
                            _profile!.photoPath != null &&
                            File(_profile!.photoPath!).existsSync())
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ClipOval(
                              child: Image.file(
                                File(_profile!.photoPath!),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ListTile(
                          title: Text(_profile!.fullName),
                          subtitle: Text('${_profile!.region ?? "N/A"} • ${_profile!.farmSizeHectares ?? "N/A"} ha'),
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
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: buttons
                    .map((btn) => _buildGridButton(
                          btn['label'] as String,
                          btn['route'] as String,
                          btn['icon'] as IconData,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
