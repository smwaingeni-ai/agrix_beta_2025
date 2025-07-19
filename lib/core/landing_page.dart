import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agrix_africa_adt2025/models/farmer_profile.dart';
import 'package:agrix_africa_adt2025/services/profile/farmer_profile_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

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
    final profile = await FarmerProfileService.loadActiveProfile();
    setState(() => _profile = profile);
  }

  Future<void> _deleteProfile() async {
    await FarmerProfileService.clearActiveProfile();
    setState(() => _profile = null);
  }

  void _shareProfile() {
    if (_profile == null) return;

    final profileText = '''
👤 Name: ${_profile!.name}
📞 Contact: ${_profile!.contact}
🌍 Region: ${_profile!.region ?? 'N/A'}
📐 Farm Size: ${_profile!.farmSize}
🏛️ Subsidised: ${_profile!.subsidised ? "Yes" : "No"}
''';
    Share.share(profileText);
  }

  Widget buildGridButton(String label, String route) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.arrow_forward_ios),
      label: Text(label, textAlign: TextAlign.center),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'label': 'Scan / Upload Image', 'route': '/upload'},
      {'label': 'Get Advice', 'route': '/advice'},
      {'label': 'Logbook', 'route': '/logbook'},
      {'label': 'Market', 'route': '/market'},
      {'label': 'Loan', 'route': '/loan'},
      {'label': 'AgriGPT', 'route': '/agrigpt'},
      {'label': 'AgriGPT Chat', 'route': '/chat'},
      {'label': 'Crops', 'route': '/crops'},
      {'label': 'Field Assessments', 'route': '/fieldAssessment'},
      {'label': 'Farming Tips', 'route': '/tips'},
      {'label': 'Contract Offers', 'route': '/contracts/list'},
      {'label': 'Submit Offer', 'route': '/contracts/new'},
      {'label': 'Investor Portal', 'route': '/investor/register'},
      {'label': 'AREX Tasks', 'route': '/officer/tasks'},
      {'label': 'AREX Assessments', 'route': '/officer/assessments'},
      {'label': 'Sync & Backup', 'route': '/sync'},
      {'label': 'Notifications', 'route': '/notifications'},
      {'label': 'Help & FAQs', 'route': '/help'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriX Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.pushNamed(context, '/profile').then((_) => _loadProfile());
            },
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
                          title: Text(_profile!.name),
                          subtitle: Text(
                              '${_profile!.region ?? "N/A"} • ${_profile!.farmSize} ha'),
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
                    label: const Text('Create Profile'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile').then((_) => _loadProfile());
                    },
                  ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children:
                    buttons.map((btn) => buildGridButton(btn['label']!, btn['route']!)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
