import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/officers/officer_profile.dart';
import 'package:agrix_beta_2025/services/officers/officer_profile_service.dart';

class OfficerProfileScreen extends StatefulWidget {
  const OfficerProfileScreen({Key? key}) : super(key: key);

  @override
  State<OfficerProfileScreen> createState() => _OfficerProfileScreenState();
}

class _OfficerProfileScreenState extends State<OfficerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  OfficerProfile _profile = OfficerProfile.empty();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loaded = await OfficerProfileService.loadProfile();
    if (loaded != null) {
      setState(() {
        _profile = loaded;
        _nameController.text = loaded.name;
        _designationController.text = loaded.designation;
        _contactController.text = loaded.contact;
        _regionController.text = loaded.region;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updated = OfficerProfile(
        name: _nameController.text.trim(),
        designation: _designationController.text.trim(),
        contact: _contactController.text.trim(),
        region: _regionController.text.trim(),
      );

      await OfficerProfileService.saveProfile(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Profile saved')),
        );
      }
    }
  }

  Future<void> _clearProfile() async {
    await OfficerProfileService.deleteProfile();
    setState(() {
      _profile = OfficerProfile.empty();
      _nameController.clear();
      _designationController.clear();
      _contactController.clear();
      _regionController.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🧹 Profile cleared')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _contactController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Officer Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(labelText: 'Designation'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter designation' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Info'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter contact' : null,
              ),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: 'Region'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter region' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Clear Profile'),
                onPressed: _clearProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
