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
      initialDate: isStart ? DateTime.now() : (_startDate ?? DateTime.now()).add(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and select dates.')),
      );
      return;
    }

    final agreement = InvestmentAgreement(
      agreementId: const Uuid().v4(),
      farmerName: _farmerNameController.text,
      investorName: _investorNameController.text,
      amount: double.parse(_amountController.text),
      currency: _currencyController.text,
      terms: _termsController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      status: _status,
    );

    await InvestmentAgreementService().saveAgreement(agreement);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agreement submitted successfully.')),
    );

    Navigator.of(context).pop(); // go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Investment Agreement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _farmerNameController,
                decoration: const InputDecoration(labelText: 'Farmer Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _investorNameController,
                decoration: const InputDecoration(labelText: 'Investor Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final parsed = double.tryParse(value);
                  return parsed == null ? 'Enter valid number' : null;
                },
              ),
              TextFormField(
                controller: _currencyController,
                decoration: const InputDecoration(labelText: 'Currency'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _termsController,
                decoration: const InputDecoration(labelText: 'Terms'),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Start Date:'),
                  const SizedBox(width: 10),
                  Text(_startDate == null
                      ? 'Not selected'
                      : DateFormat.yMMMd().format(_startDate!)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('End Date:'),
                  const SizedBox(width: 10),
                  Text(_endDate == null
                      ? 'Not selected'
                      : DateFormat.yMMMd().format(_endDate!)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Pending', 'Active', 'Completed']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Status'),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _status = val);
                  }
                },
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
