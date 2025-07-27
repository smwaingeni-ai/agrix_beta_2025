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

  final _farmerNameController = TextEditingController();
  final _investorNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController();
  final _termsController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _status = 'Pending';

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        isStart ? _startDate = picked : _endDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Fill all fields and pick dates.')),
      );
      return;
    }

    final agreement = InvestmentAgreement(
      agreementId: const Uuid().v4(),
      farmerName: _farmerNameController.text.trim(),
      investorName: _investorNameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      currency: _currencyController.text.trim(),
      terms: _termsController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      status: _status,
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

  Widget _buildDateRow(String label, DateTime? date, bool isStart) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            date != null ? DateFormat.yMMMd().format(date) : 'Not selected',
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context, isStart),
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
              _buildTextField(controller: _farmerNameController, label: 'Farmer Name'),
              _buildTextField(controller: _investorNameController, label: 'Investor Name'),
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
              _buildDateRow('Start Date', _startDate, true),
              _buildDateRow('End Date', _endDate, false),
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
