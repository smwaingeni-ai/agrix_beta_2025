import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/services/profile/investments/investor_service.dart';
import 'package:agrix_beta_2025/models/investments/investment_horizon.dart';

class InvestorRegistrationScreen extends StatefulWidget {
  @override
  _InvestorRegistrationScreenState createState() => _InvestorRegistrationScreenState();
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final investor = InvestorProfile(
        id: Uuid().v4(),
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

      InvestorService().saveInvestor(investor);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Investor Registered Successfully!')),
      );

      Navigator.pop(context);
    }
  }

  Widget _buildChipSelector({
    required String title,
    required List<String> options,
    required List<String> selectedValues,
    required void Function(String, bool) onSelected,
    bool isChoiceChip = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return isChoiceChip
                ? ChoiceChip(
                    label: Text(option),
                    selected: selectedValues.contains(option),
                    onSelected: (selected) => setState(() {
                      onSelected(option, selected);
                    }),
                  )
                : FilterChip(
                    label: Text(option),
                    selected: selectedValues.contains(option),
                    onSelected: (selected) => setState(() {
                      onSelected(option, selected);
                    }),
                  );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Investor Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Invalid email';
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your phone number' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your country' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Preferred Contact Method',
                  helperText: 'e.g. WhatsApp, Email, Call',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a contact method' : null,
              ),
              _buildChipSelector(
                title: "Investment Horizon",
                options: _horizons,
                selectedValues: _selectedHorizons,
                onSelected: (option, selected) {
                  selected
                      ? _selectedHorizons.add(option)
                      : _selectedHorizons.remove(option);
                },
              ),
              _buildChipSelector(
                title: "Investment Interests",
                options: _interests,
                selectedValues: _selectedInterests,
                isChoiceChip: false,
                onSelected: (option, selected) {
                  selected
                      ? _selectedInterests.add(option)
                      : _selectedInterests.remove(option);
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Investment Status'),
                value: _selectedStatus,
                onChanged: (value) => setState(() => _selectedStatus = value!),
                items: ['Open', 'Indifferent', 'Not Open']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(FontAwesomeIcons.userPlus),
                label: Text('Register'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
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
