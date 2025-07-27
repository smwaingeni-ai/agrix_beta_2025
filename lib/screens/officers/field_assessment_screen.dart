import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FieldAssessmentScreen extends StatefulWidget {
  const FieldAssessmentScreen({super.key});

  @override
  State<FieldAssessmentScreen> createState() => _FieldAssessmentScreenState();
}

class _FieldAssessmentScreenState extends State<FieldAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _recommendationsController = TextEditingController();

  @override
  void dispose() {
    _cropController.dispose();
    _observationsController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  Future<void> _submitAssessment() async {
    if (!_formKey.currentState!.validate()) return;

    final newAssessment = {
      'id': _uuid.v4(),
      'timestamp': DateTime.now().toIso8601String(),
      'crop': _cropController.text.trim(),
      'observations': _observationsController.text.trim(),
      'recommendations': _recommendationsController.text.trim(),
    };

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/field_assessments.json');

      List<dynamic> existing = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) existing = json.decode(content);
      }

      existing.add(newAssessment);
      await file.writeAsString(json.encode(existing), flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Field assessment saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to save: $e')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧾 Field Assessment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(controller: _cropController, label: '🌱 Crop Type'),
              _buildTextField(
                controller: _observationsController,
                label: '👀 Observations',
                maxLines: 4,
              ),
              _buildTextField(
                controller: _recommendationsController,
                label: '✅ Recommendations',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Submit Assessment'),
                onPressed: _submitAssessment,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
