import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:agrix_africa_adt2025/models/farmer_profile.dart';
import 'package:agrix_africa_adt2025/services/profile/farmer_profile_service.dart';

class LandingPage extends StatefulWidget {
  final FarmerProfile loggedInUser;

  const LandingPage({Key? key, required this.loggedInUser}) : super(key: key);

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
    final loadedProfile = await FarmerProfileService.loadActiveProfile();
    setState(() {
      _profile = loadedProfile;
    });
  }

  Future<void> _deleteProfile() async {
    await FarmerProfileService.clearActiveProfile();
    setState(() {
      _profile = null;
    });
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
        title: const Text('AgriX Beta – ADT 2025'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
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
            Column(
              children: [
                Image.asset('assets/alogo.png', height: 100),
                const SizedBox(height: 8),
                const Text(
                  'AgriX – Smart Economies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '👋 Welcome ${widget.loggedInUser.name} (${widget.loggedInUser.idNumber})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            if (_profile != null)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                child: Column(
                  children: [
                    if (_profile!.photoPath != null &&
                        File(_profile!.photoPath!).existsSync()) ...[
                      const SizedBox(height: 10),
                      const Text('📷 Farmer Photo',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_profile!.photoPath!),
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.green),
                      title: Text(_profile!.name),
                      subtitle: Text(
                        '${_profile!.region ?? "N/A"}\nFarm Size: ${_profile!.farmSize} • Subsidised: ${_profile!.subsidised ? "Yes" : "No"}',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile')
                                  .then((_) => _loadProfile());
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text("Share"),
                            onPressed: _shareProfile,
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: _deleteProfile,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Create Farmer Profile'),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile')
                      .then((_) => _loadProfile());
                },
              ),
            const SizedBox(height: 16),
            const Text(
              'Your AI-powered farming assistant.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: buttons
                    .map((btn) => buildGridButton(btn['label']!, btn['route']!))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
