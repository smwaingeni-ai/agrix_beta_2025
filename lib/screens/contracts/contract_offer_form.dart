import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';
import 'package:agrix_beta_2025/services/contracts/contract_service.dart';

class ContractOfferForm extends StatefulWidget {
  const ContractOfferForm({super.key});

  @override
  State<ContractOfferForm> createState() => _ContractOfferFormState();
}

class _ContractOfferFormState extends State<ContractOfferForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _contactController = TextEditingController();
  final _partiesController = TextEditingController();
  final _amountController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _termsController = TextEditingController();

  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _paymentTermsController.dispose();
    _contactController.dispose();
    _partiesController.dispose();
    _amountController.dispose();
    _cropTypeController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final offer = ContractOffer(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        duration: _durationController.text.trim(),
        paymentTerms: _paymentTermsController.text.trim(),
        contact: _contactController.text.trim(),
        parties: _partiesController.text
            .split(',')
            .map((p) => p.trim())
            .where((p) => p.isNotEmpty)
            .toList(),
        amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
        cropOrLivestockType: _cropTypeController.text.trim(),
        terms: _termsController.text.trim(),
        isActive: _isActive,
        postedAt: DateTime.now(),
      );

      try {
        await ContractService.addContractOffer(offer);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Contract offer saved successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to save: $e')),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
    int maxLines = 1,
    bool autofocus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) =>
                (value == null || value.trim().isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Contract Offer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                required: true,
                autofocus: true,
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
                required: true,
              ),
              _buildTextField(controller: _locationController, label: 'Location'),
              _buildTextField(
                controller: _durationController,
                label: 'Duration',
                hint: 'e.g., 3 months, 1 year',
              ),
              _buildTextField(
                controller: _paymentTermsController,
                label: 'Payment Terms',
              ),
              _buildTextField(
                controller: _contactController,
                label: 'Contact',
                required: true,
              ),
              _buildTextField(
                controller: _partiesController,
                label: 'Parties',
                hint: 'Comma-separated: e.g., Buyer, Seller',
                required: true,
              ),
              _buildTextField(
                controller: _amountController,
                label: 'Amount',
                hint: 'e.g., 1000.00',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _cropTypeController,
                label: 'Crop/Livestock Type',
              ),
              _buildTextField(
                controller: _termsController,
                label: 'Contract Terms',
                maxLines: 3,
              ),
              SwitchListTile(
                title: const Text('Is Active?'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: _isSubmitting
                      ? const Text('Saving...')
                      : const Text('Save Contract'),
                  onPressed: _isSubmitting ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
