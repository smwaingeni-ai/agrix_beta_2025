import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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

  final _investorIdController = TextEditingController();
  final _investorNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController(text: 'General');

  double _amount = 0.0;
  double _interestRate = 0.0;
  InvestmentHorizon? _selectedHorizon;

  @override
  void dispose() {
    _investorIdController.dispose();
    _investorNameController.dispose();
    _contactController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _submitOffer() async {
    if (!_formKey.currentState!.validate() || _selectedHorizon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Please fill all required fields.')),
      );
      return;
    }

    _formKey.currentState!.save();
    final now = DateTime.now();
    final id = const Uuid().v4();

    final offer = InvestmentOffer(
      id: id,
      listingId: 'listing_$id',
      investorId: _investorIdController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _typeController.text.trim(),
      amount: _amount,
      parties: [_investorIdController.text.trim()],
      contact: _contactController.text.trim(),
      status: 'Open',
      postedAt: now,
      currency: 'USD',
      investorName: _investorNameController.text.trim(),
      interestRate: _interestRate,
      term: _selectedHorizon!.label,
      isAccepted: false,
      timestamp: now,
      createdAt: now,
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
              _buildTextField(controller: _investorIdController, label: 'Investor ID'),
              _buildTextField(controller: _investorNameController, label: 'Investor Name'),
              _buildTextField(controller: _contactController, label: 'Contact Info'),
              _buildTextField(controller: _titleController, label: 'Offer Title'),
              _buildTextField(controller: _descriptionController, label: 'Description', maxLines: 3),
              _buildTextField(controller: _typeController, label: 'Type (Crop, Livestock, etc.)'),
              _buildTextField(
                label: 'Amount (USD)',
                keyboardType: TextInputType.number,
                onSaved: (val) => _amount = double.tryParse(val ?? '0') ?? 0.0,
                validator: (val) {
                  final parsed = double.tryParse(val ?? '');
                  return (parsed == null || parsed <= 0) ? 'Enter a valid amount' : null;
                },
              ),
              _buildTextField(
                label: 'Interest Rate (%)',
                keyboardType: TextInputType.number,
                onSaved: (val) => _interestRate = double.tryParse(val ?? '0') ?? 0.0,
                validator: (val) {
                  final parsed = double.tryParse(val ?? '');
                  return (parsed == null || parsed < 0) ? 'Enter a valid interest rate' : null;
                },
              ),
              const SizedBox(height: 12),
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
                validator: (value) => value == null ? 'Please select a term' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit Offer'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _submitOffer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        onSaved: onSaved,
        validator: validator ?? (val) => val == null || val.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
