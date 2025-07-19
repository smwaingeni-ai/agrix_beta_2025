import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';

class EditFarmerProfileScreen extends StatefulWidget {
  const EditFarmerProfileScreen({super.key});

  @override
  State<EditFarmerProfileScreen> createState() => _EditFarmerProfileScreenState();
}

class _EditFarmerProfileScreenState extends State<EditFarmerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  FarmerProfile? _profile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _farmLocationController = TextEditingController();

  bool _govtAffiliated = false;
  bool _subsidised = false;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loadedProfile = await FarmerProfileService.loadActiveProfile();
    if (loadedProfile != null) {
      setState(() {
        _profile = loadedProfile;
        _nameController.text = loadedProfile.fullName;
        _idController.text = loadedProfile.id;
        _contactController.text = loadedProfile.contactNumber;
        _farmSizeController.text = loadedProfile.farmSizeHectares?.toString() ?? '';
        _regionController.text = loadedProfile.region ?? '';
        _provinceController.text = loadedProfile.province ?? '';
        _districtController.text = loadedProfile.district ?? '';
        _farmLocationController.text = loadedProfile.farmLocation ?? '';
        _govtAffiliated = loadedProfile.govtAffiliated;
        _subsidised = loadedProfile.subsidised;
        _photoPath = loadedProfile.photoPath;
      });
    }
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _photoPath = picked.path);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = FarmerProfile(
      farmerId: _profile?.farmerId ?? '',
      fullName: _nameController.text,
      id: _idController.text,
      contactNumber: _contactController.text,
      farmSizeHectares: double.tryParse(_farmSizeController.text),
      govtAffiliated: _govtAffiliated,
      subsidised: _subsidised,
      region: _regionController.text,
      province: _provinceController.text,
      district: _districtController.text,
      farmLocation: _farmLocationController.text,
      registeredAt: _profile?.registeredAt ?? DateTime.now(),
      photoPath: _photoPath,
      qrImagePath: _profile?.qrImagePath,
    );

    await FarmerProfileService.saveProfile(updatedProfile);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Farmer Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _photoPath != null && File(_photoPath!).existsSync()
                      ? FileImage(File(_photoPath!))
                      : null,
                  child: _photoPath == null ? const Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              const SizedBox(height: 16),
              _buildField("Full Name", _nameController),
              _buildField("ID Number", _idController),
              _buildField("Phone", _contactController, keyboardType: TextInputType.phone),
              _buildField("Farm Size (ha)", _farmSizeController, keyboardType: TextInputType.number),
              _buildField("Region", _regionController),
              _buildField("Province", _provinceController),
              _buildField("District", _districtController),
              _buildField("Farm Location", _farmLocationController),
              SwitchListTile(
                title: const Text("Government Affiliated"),
                value: _govtAffiliated,
                onChanged: (val) => setState(() => _govtAffiliated = val),
              ),
              SwitchListTile(
                title: const Text("Subsidised"),
                value: _subsidised,
                onChanged: (val) => setState(() => _subsidised = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: _saveProfile,
                label: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
