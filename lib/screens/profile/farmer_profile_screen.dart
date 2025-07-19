import 'dart:io';
import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/farmer_profile_service.dart';

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
        _idController.text = profile.idNumber ?? '';
        _contactController.text = profile.contact;
        _farmSizeController.text = profile.farmSize ?? '';
        _subsidised = profile.subsidised ?? false;
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
      farmerId: _idController.text,
      fullName: _nameController.text,
      idNumber: _idController.text,
      contact: _contactController.text,
      farmSize: _farmSizeController.text,
      subsidised: _subsidised,
      photoPath: _imagePath,
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
                  backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID Number'),
                validator: (value) => value!.isEmpty ? 'Enter ID' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                validator: (value) => value!.isEmpty ? 'Enter contact' : null,
              ),
              TextFormField(
                controller: _farmSizeController,
                decoration: const InputDecoration(labelText: 'Farm Size'),
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
