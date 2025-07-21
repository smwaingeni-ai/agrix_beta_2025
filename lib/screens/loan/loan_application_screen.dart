// /lib/screens/loans/loan_application.dart

import 'package:flutter/material.dart';
import 'package:agrix_africa_adt2025/models/farmer_profile.dart' as model;
import 'package:agrix_africa_adt2025/services/profile/farmer_profile_service.dart' as service;

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  model.FarmerProfile? _selectedFarmer;
  final Map<String, model.FarmerProfile> _farmerMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmers();
  }

  Future<void> _loadFarmers() async {
    try {
      final farmers = await service.FarmerProfileService.loadProfiles();
      if (mounted) {
        setState(() {
          for (var farmer in farmers) {
            _farmerMap[farmer.farmerId] = farmer;
          }
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading farmers: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading farmers. Please try again later.')),
      );
    }
  }

  double _scoreFarmer(model.FarmerProfile farmer) {
    double score = (farmer.farmSizeHectares ?? 0.0) * (farmer.govtAffiliated ? 1.5 : 1.0);
    return score.clamp(0, 100);
  }

  void _submitLoanApplication() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    final score = _scoreFarmer(_selectedFarmer!);
    final approved = score > 30;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Loan Application Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              approved
                  ? '✅ Loan Approved for ${_selectedFarmer!.displayName}'
                  : '❌ Loan Not Approved for ${_selectedFarmer!.displayName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Score: ${score.toStringAsFixed(1)}'),
            Text('Requested Amount: ZMW ${amount!.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Loan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<model.FarmerProfile>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Select Farmer',
                        border: OutlineInputBorder(),
                      ),
                      items: _farmerMap.values.map((farmer) {
                        return DropdownMenuItem<model.FarmerProfile>(
                          value: farmer,
                          child: Text('${farmer.displayName} (${farmer.govtAffiliated ? 'Govt' : 'Private'})'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedFarmer = value),
                      validator: (value) => value == null ? 'Please select a farmer' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Loan Amount (ZMW)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final amt = double.tryParse(value ?? '');
                        if (amt == null || amt <= 0) {
                          return 'Enter a valid loan amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _submitLoanApplication,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Submit Loan Application'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
