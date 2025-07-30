import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:agrix_beta_2025/models/investments/investment_agreement.dart';
import 'package:agrix_beta_2025/services/investments/investment_agreement_service.dart';

class InvestmentAgreementForm extends StatefulWidget {
  const InvestmentAgreementForm({Key? key}) : super(key: key);

  @override
  State<InvestmentAgreementForm> createState() => _InvestmentAgreementFormState();
}

class _InvestmentAgreementFormState extends State<InvestmentAgreementForm> {
  final _formKey = GlobalKey<FormState>();

  final _offerIdController = TextEditingController();
  final _investorIdController = TextEditingController();
  final _investorNameController = TextEditingController();
  final _farmerIdController = TextEditingController();
  final _farmerNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _termsController = TextEditingController();

  DateTime? _agreementDate;
  String _status = 'Pending';

  Future<void> _selectAgreementDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _agreementDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _agreementDate = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _agreementDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Fill all fields and select a date.')),
      );
      return;
    }

    final agreement = InvestmentAgreement(
      agreementId: const Uuid().v4(),
      offerId: _offerIdController.text.trim(),
      investorId: _investorIdController.text.trim(),
      investorName: _investorNameController.text.trim(),
      farmerId: _farmerIdController.text.trim(),
      farmerName: _farmerNameController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
      currency: _currencyController.text.trim(),
      terms: _termsController.text.trim(),
      agreementDate: _agreementDate!,
      startDate: _agreementDate!, // ✅ Ensure this aligns with model
      status: _status,
      documentUrl: null,
    );

    await InvestmentAgreementService().saveAgreement(agreement);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Agreement saved successfully!')),
    );
    Navigator.of(context).pop();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) => value == null || value.trim().isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date != null ? DateFormat.yMMMd().format(date) : 'Not selected'),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectAgreementDate(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📑 New Investment Agreement')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(controller: _offerIdController, label: 'Offer ID'),
              _buildTextField(controller: _investorIdController, label: 'Investor ID'),
              _buildTextField(controller: _investorNameController, label: 'Investor Name'),
              _buildTextField(controller: _farmerIdController, label: 'Farmer ID'),
              _buildTextField(controller: _farmerNameController, label: 'Farmer Name'),
              _buildTextField(
                controller: _amountController,
                label: 'Amount',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(controller: _currencyController, label: 'Currency'),
              _buildTextField(
                controller: _termsController,
                label: 'Terms & Conditions',
                maxLines: 4,
              ),
              _buildDateRow('Agreement Date', _agreementDate),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Pending', 'Active', 'Completed']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Status'),
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Submit Agreement'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
