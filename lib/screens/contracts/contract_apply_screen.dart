import 'package:flutter/material.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';
import 'package:agrix_beta_2025/services/contracts/contract_application_service.dart';

class ContractApplyScreen extends StatefulWidget {
  final ContractOffer offer;

  const ContractApplyScreen({super.key, required this.offer});

  @override
  State<ContractApplyScreen> createState() => _ContractApplyScreenState();
}

class _ContractApplyScreenState extends State<ContractApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmerNameController = TextEditingController();
  final _farmLocationController = TextEditingController();
  final _contactInfoController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ContractApplicationService().saveApplication(
        offerId: widget.offer.id,
        farmerName: _farmerNameController.text.trim(),
        farmLocation: _farmLocationController.text.trim(),
        contactInfo: _contactInfoController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Application submitted successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error submitting application: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _farmerNameController.dispose();
    _farmLocationController.dispose();
    _contactInfoController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply to "${offer.title}"'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please fill in your details to apply for this contract.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _farmerNameController,
                decoration: const InputDecoration(
                  labelText: '👤 Farmer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _farmLocationController,
                decoration: const InputDecoration(
                  labelText: '📍 Farm Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter farm location' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _contactInfoController,
                decoration: const InputDecoration(
                  labelText: '📞 Contact Info (Phone or Email)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Provide contact info' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '📝 Additional Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: Text(_isSubmitting ? 'Submitting...' : 'Submit Application'),
                  onPressed: _isSubmitting ? null : _submitApplication,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
