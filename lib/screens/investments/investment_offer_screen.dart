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
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final now = DateTime.now();
    final offer = InvestmentOffer(
      id: now.millisecondsSinceEpoch.toString(),
      listingId: 'listing_${now.millisecondsSinceEpoch}',
      investorId: _investorId,
      investorName: _investorName,
      amount: _amount,
      currency: 'USD', // ✅ Required field added
      term: _selectedHorizon!.code,
      interestRate: _interestRate,
      isAccepted: false,
      contact: _contact,
      timestamp: now,
    );

    try {
      await MarketService.addOffer(offer);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Investment offer submitted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error submitting offer: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
                onSaved: (val) => _investorId = val!.trim(),
              ),
              _buildTextField(
                label: 'Investor Name',
                onSaved: (val) => _investorName = val!.trim(),
              ),
              _buildTextField(
                label: 'Contact Info',
                onSaved: (val) => _contact = val!.trim(),
              ),
              _buildTextField(
                label: 'Amount (USD)',
                keyboardType: TextInputType.number,
                onSaved: (val) => _amount = double.tryParse(val ?? '0') ?? 0.0,
                validator: (val) {
                  final parsed = double.tryParse(val ?? '');
                  return (parsed == null || parsed <= 0)
                      ? 'Enter a valid amount'
                      : null;
                },
              ),
              _buildTextField(
                label: 'Interest Rate (%)',
                keyboardType: TextInputType.number,
                onSaved: (val) => _interestRate = double.tryParse(val ?? '0') ?? 0.0,
                validator: (val) {
                  final parsed = double.tryParse(val ?? '');
                  return (parsed == null || parsed < 0)
                      ? 'Enter a valid interest rate'
                      : null;
                },
              ),
              DropdownButtonFormField<InvestmentHorizon>(
                value: _selectedHorizon,
                decoration: const InputDecoration(
                  labelText: 'Investment Term',
                  border: OutlineInputBorder(),
                ),
                items: InvestmentHorizon.values.map((h) {
                  return DropdownMenuItem(
                    value: h,
                    child: Text(h.label),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedHorizon = value),
                validator: (value) =>
                    value == null ? 'Please select a term' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Offer'),
                  onPressed: _submitOffer,
                ),
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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator ??
            (val) => val == null || val.trim().isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }
}
