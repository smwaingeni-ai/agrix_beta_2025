import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';
import 'package:agrix_beta_2025/services/auth/session_service.dart';

import 'package:agrix_beta_2025/screens/core/auth_gate.dart';

class LandingPage extends StatefulWidget {
  final FarmerProfile? farmer;

  const LandingPage({Key? key, this.farmer}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FarmerProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (widget.farmer != null) {
      _profile = widget.farmer!;
    } else {
      _profile = await FarmerProfileService.loadActiveProfile();
    }
    setState(() {});
  }

  Future<void> _deleteProfile() async {
    await FarmerProfileService.clearActiveProfile();
    setState(() => _profile = null);
  }

  void _shareProfile() {
    if (_profile == null) return;

    final profileText = '''
👤 Name: ${_profile!.fullName}
🆔 ID: ${_profile!.idNumber}
📞 Contact: ${_profile!.contactNumber}
📐 Farm Size: ${_profile!.farmSizeHectares ?? 'N/A'}
🌍 Region: ${_profile!.region ?? 'N/A'}
🏛️ Subsidised: ${_profile!.subsidised ? "Yes" : "No"}
''';
    Share.share(profileText);
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

  Widget buildGridButton(String label, String route, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label, textAlign: TextAlign.center),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'label': 'Edit Profile', 'route': 'editFarmerProfile', 'icon': Icons.edit},
      {'label': 'Loan Dashboard', 'route': 'loan', 'icon': Icons.account_balance},
      {'label': 'Apply for Loan', 'route': 'loanApplication', 'icon': Icons.assignment},
      {'label': 'My Loans', 'route': 'loanList', 'icon': Icons.receipt_long},
      {'label': 'Training Log', 'route': 'trainingLog', 'icon': Icons.school},
      {'label': 'Sustainability', 'route': 'sustainabilityLog', 'icon': Icons.eco},
      {'label': 'Notifications', 'route': 'notifications', 'icon': Icons.notifications},
      {'label': 'Help', 'route': 'help', 'icon': Icons.help_outline},
      {'label': 'Chat', 'route': 'chat', 'icon': Icons.chat},
    ];

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
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        if (_profile!.photoPath != null &&
                            File(_profile!.photoPath!).existsSync()) ...[
                          const SizedBox(height: 8),
                          Image.file(
                            File(_profile!.photoPath!),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                        ],
                        ListTile(
                          title: Text(_profile!.fullName),
                          subtitle: Text(
                            '${_profile!.region ?? "N/A"} • ${_profile!.farmSizeHectares ?? "N/A"} ha',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: _shareProfile,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: _deleteProfile,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Create Farmer Profile'),
                    onPressed: () {
                      Navigator.pushNamed(context, 'farmerProfile')
                          .then((_) => _loadProfile());
                    },
                  ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: buttons
                    .map((btn) => buildGridButton(
                        btn['label']!, btn['route']!, btn['icon']! as IconData))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
