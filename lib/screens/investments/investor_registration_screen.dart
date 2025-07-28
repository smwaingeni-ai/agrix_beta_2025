import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/models/investments/investment_horizon.dart';
import 'package:agrix_beta_2025/models/investments/investor_status.dart';
import 'package:agrix_beta_2025/services/investments/cloud_investor_service.dart';

class InvestorRegistrationScreen extends StatefulWidget {
  final String? userId;
  final String? name;

  const InvestorRegistrationScreen({super.key, this.userId, this.name});

  @override
  State<InvestorRegistrationScreen> createState() => _InvestorRegistrationScreenState();
}

class _InvestorRegistrationScreenState extends State<InvestorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  List<String> _selectedHorizons = [];
  List<String> _selectedInterests = [];
  String _selectedStatus = 'Open';

  final List<String> _horizons = ['Short Term', 'Mid Term', 'Long Term'];
  final List<String> _interests = ['Crops', 'Livestock', 'Soil', 'Technology'];
  final List<String> _statuses = ['Open', 'Indifferent', 'Not Open'];

  @override
  void initState() {
    super.initState();
    if (widget.name != null) _nameController.text = widget.name!;
    if (widget.userId != null) _phoneController.text = widget.userId!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final investor = InvestorProfile(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      contactNumber: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      contact: _contactController.text.trim(),
      preferredHorizons: _selectedHorizons
          .map((label) => InvestmentHorizonExtension.fromLabel(label))
          .whereType<InvestmentHorizon>()
          .toList(),
      interests: _selectedInterests,
      status: InvestorStatusExtension.fromString(_selectedStatus),
      registeredAt: DateTime.now(),
    );

    try {
      await CloudInvestorService().saveInvestor(investor); // ✅ FIXED

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Investor Registered Successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('❌ Error saving investor: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to register investor')),
        );
      }
    }
  }

  Widget _buildChipSelector({
    required String title,
    required List<String> options,
    required List<String> selectedValues,
    required bool isMulti,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return isMulti
                ? FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? selectedValues.add(option)
                            : selectedValues.remove(option);
                      });
                    },
                  )
                : ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedValues.clear();
                        if (selected) selectedValues.add(option);
                      });
                    },
                  );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    String? helper,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, helperText: helper),
        keyboardType: inputType,
        validator: validator ?? (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Investor Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextInput(controller: _nameController, label: 'Full Name'),
              _buildTextInput(
                controller: _emailController,
                label: 'Email',
                inputType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter your email';
                  final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  return !emailReg.hasMatch(val) ? 'Invalid email' : null;
                },
              ),
              _buildTextInput(controller: _phoneController, label: 'Phone Number'),
              _buildTextInput(controller: _locationController, label: 'Country'),
              _buildTextInput(
                controller: _contactController,
                label: 'Preferred Contact Method',
                helper: 'e.g. WhatsApp, Email, Call',
              ),
              _buildChipSelector(
                title: "Investment Horizons",
                options: _horizons,
                selectedValues: _selectedHorizons,
                isMulti: true,
              ),
              _buildChipSelector(
                title: "Investment Interests",
                options: _interests,
                selectedValues: _selectedInterests,
                isMulti: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Investment Status'),
                value: _selectedStatus,
                onChanged: (val) => setState(() => _selectedStatus = val!),
                items: _statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(FontAwesomeIcons.userPlus),
                label: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
