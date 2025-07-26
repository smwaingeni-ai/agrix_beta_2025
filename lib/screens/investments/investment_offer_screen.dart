import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/investments/investment_horizon.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';
import 'package:agrix_beta_2025/services/market/market_service.dart';

class InvestmentOfferScreen extends StatefulWidget {
  const InvestmentOfferScreen({super.key});

  @override
  State<InvestmentOfferScreen> createState() => _InvestmentOfferScreenState();
}

class _InvestmentOfferScreenState extends State<InvestmentOfferScreen> {
  final _formKey = GlobalKey<FormState>();

  String _investorId = '';
  String _investorName = '';
  String _contact = '';
  double _amount = 0.0;
  double _interestRate = 0.0;
  InvestmentHorizon? _selectedHorizon;

  Future<void> _submitOffer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final now = DateTime.now();
      final offer = InvestmentOffer(
        id: now.millisecondsSinceEpoch.toString(),
        listingId: 'listing_${now.millisecondsSinceEpoch}',
        investorId: _investorId,
        investorName: _investorName,
        amount: _amount,
        term: _selectedHorizon!.code,
        interestRate: _interestRate,
        isAccepted: false,
        contact: _contact,
        timestamp: now,
      );

      try {
        await MarketService.addOffer(offer);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Investment offer submitted successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error submitting offer: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💰 Investment Offer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'Investor ID',
                onSaved: (value) => _investorId = value!,
              ),
              _buildTextField(
                label: 'Investor Name',
                onSaved: (value) => _investorName = value!,
              ),
              _buildTextField(
                label: 'Contact',
                onSaved: (value) => _contact = value!,
              ),
              _buildTextField(
                label: 'Amount (USD)',
                keyboardType: TextInputType.number,
                onSaved: (value) => _amount = double.parse(value!),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  return (parsed == null || parsed <= 0)
                      ? 'Enter a valid amount'
                      : null;
                },
              ),
              _buildTextField(
                label: 'Interest Rate (%)',
                keyboardType: TextInputType.number,
                onSaved: (value) => _interestRate = double.parse(value!),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  return (parsed == null || parsed < 0)
                      ? 'Enter a valid interest rate'
                      : null;
                },
              ),
              DropdownButtonFormField<InvestmentHorizon>(
                decoration: const InputDecoration(labelText: 'Investment Term'),
                value: _selectedHorizon,
                items: InvestmentHorizon.values.map((horizon) {
                  return DropdownMenuItem(
                    value: horizon,
                    child: Text(horizon.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHorizon = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Select an investment term' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit Offer'),
                onPressed: _submitOffer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        validator: validator ??
            (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }
}
