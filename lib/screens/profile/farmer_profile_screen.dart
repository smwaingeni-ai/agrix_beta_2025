import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_farmer_profile_screen.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart' as model;
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart' as service;

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  Future<model.FarmerProfile?>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = service.FarmerProfileService.loadActiveProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = service.FarmerProfileService.loadActiveProfile();
    });
  }

  void _launchWhatsApp(BuildContext context, String phone) async {
    final Uri whatsappUrl = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<model.FarmerProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snapshot.data;

        if (profile == null) {
          return const Scaffold(
            body: Center(child: Text('No profile found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Farmer Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditFarmerProfileScreen(),
                    ),
                  ).then((_) => _refreshProfile());
                },
              ),
              if (profile.contactNumber.isNotEmpty)
                IconButton(
                  icon: const Icon(FontAwesomeIcons.whatsapp),
                  tooltip: 'Message on WhatsApp',
                  onPressed: () => _launchWhatsApp(context, profile.contactNumber),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: (profile.photoPath != null &&
                            profile.photoPath!.isNotEmpty &&
                            File(profile.photoPath!).existsSync())
                        ? FileImage(File(profile.photoPath!))
                        : null,
                    child: (profile.photoPath == null || profile.photoPath!.isEmpty)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                _infoTile("Full Name", profile.fullName),
                _infoTile("ID", profile.id),
                _infoTile("Phone", profile.contactNumber),
                _infoTile("Farm Size", "${profile.farmSizeHectares?.toStringAsFixed(2) ?? 'N/A'} hectares"),
                _infoTile("Government Affiliated", profile.govtAffiliated ? "Yes" : "No"),
                _infoTile("Subsidised", profile.subsidised ? "Yes" : "No"),
                _infoTile("Region", profile.region ?? "N/A"),
                _infoTile("Province", profile.province ?? "N/A"),
                _infoTile("District", profile.district ?? "N/A"),
                _infoTile("Farm Location", profile.farmLocation ?? "N/A"),
                if (profile.registeredAt != null)
                  _infoTile("Registered At", profile.registeredAt!.toLocal().toString().split(' ')[0]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
