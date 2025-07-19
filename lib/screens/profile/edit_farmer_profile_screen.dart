import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agrix_beta_2025/models/farmer_profile.dart';
import 'package:agrix_beta_2025/services/profile/farmer_profile_service.dart';

class EditFarmerProfileScreen extends StatefulWidget {
  const EditFarmerProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditFarmerProfileScreen> createState() => _EditFarmerProfileScreenState();
}

class _EditFarmerProfileScreenState extends State<EditFarmerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  FarmerProfile? _profile;

  final _nameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _contactController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _regionController = TextEditingController();
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _farmLocationController = TextEditingController();

  bool _govtAffiliated = false;
  bool _subsidised = false;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final loaded = await FarmerProfileService.loadActiveProfile();
    if (loaded != null) {
      setState(() {
        _profile = loaded;
        _nameController.text = loaded.fullName;
        _idNumberController.text = loaded.idNumber;
        _contactController.text = loaded.contactNumber;
        _farmSizeController.text = loaded.farmSizeHectares?.toString() ?? '';
        _regionController.text = loaded.region ?? '';
        _provinceController.text = loaded.province ?? '';
        _districtController.text = loaded.district ?? '';
        _farmLocationController.text = loaded.farmLocation ?? '';
        _govtAffiliated = loaded.govtAffiliated;
        _subsidised = loaded.subsidised;
        _photoPath = loaded.photoPath;
      });
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _photoPath = picked.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = FarmerProfile(
      farmerId: _profile?.farmerId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: _nameController.text.trim(),
      idNumber: _idNumberController.text.trim(),
      contactNumber: _contactController.text.trim(),
      farmSizeHectares: double.tryParse(_farmSizeController.text),
      region: _regionController.text.trim(),
      province: _provinceController.text.trim(),
      district: _districtController.text.trim(),
      farmLocation: _farmLocationController.text.trim(),
      govtAffiliated: _govtAffiliated,
      subsidised: _subsidised,
      photoPath: _photoPath,
      registeredAt: _profile?.registeredAt ?? DateTime.now(),
      qrImagePath: _profile?.qrImagePath,
    );

    await FarmerProfileService.saveProfile(updated);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile saved successfully!")),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.trim().isEmpty ? "Required" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Farmer Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoPath != null && File(_photoPath!).existsSync()
                      ? FileImage(File(_photoPath!))
                      : null,
                  child: _photoPath == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              _buildField("Full Name", _nameController),
              _buildField("ID Number", _idNumberController),
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
              const SizedBox(height: 24),
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
}
