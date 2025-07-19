import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({Key? key}) : super(key: key);

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _contactController = TextEditingController();
  final _farmSizeController = TextEditingController();
  bool _subsidised = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadActiveProfile();
  }

  Future<void> _loadActiveProfile() async {
    final profile = await FarmerProfileService.loadActiveProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile.fullName;
        _idController.text = profile.farmerId;
        _contactController.text = profile.contactNumber;
        _farmSizeController.text = profile.farmSizeHectares?.toString() ?? '';
        _subsidised = profile.subsidised;
        _imagePath = profile.photoPath;
      });
    }
  }

  Future<void> _pickImage() async {
    final path = await FarmerProfileService.pickProfileImage();
    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() != true) return;

    final profile = FarmerProfile(
      farmerId: _idController.text.trim(),
      fullName: _nameController.text.trim(),
      idNumber: _idController.text.trim(),
      contactNumber: _contactController.text.trim(),
      farmSizeHectares: double.tryParse(_farmSizeController.text),
      subsidised: _subsidised,
      govtAffiliated: false, // required field
      photoPath: _imagePath,
      registeredAt: DateTime.now().toIso8601String(),
    );

    await FarmerProfileService.saveProfile(profile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imagePath != null && File(_imagePath!).existsSync()
                      ? FileImage(File(_imagePath!))
                      : null,
                  child: _imagePath == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID Number'),
                validator: (value) => value == null || value.isEmpty ? 'Enter ID' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                validator: (value) => value == null || value.isEmpty ? 'Enter contact number' : null,
              ),
              TextFormField(
                controller: _farmSizeController,
                decoration: const InputDecoration(labelText: 'Farm Size (in hectares)'),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                value: _subsidised,
                onChanged: (val) => setState(() => _subsidised = val),
                title: const Text('Government Subsidised'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
