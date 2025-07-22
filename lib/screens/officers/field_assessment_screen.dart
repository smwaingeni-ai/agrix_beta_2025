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
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _recommendationsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

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
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/field_assessments.json';
      final file = File(filePath);

      List<dynamic> existingData = [];
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          existingData = json.decode(contents);
        }
      }

      existingData.add(newAssessment);
      await file.writeAsString(json.encode(existingData), flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Field assessment saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to save assessment: $e')),
      );
    }
  }

  @override
  void dispose() {
    _cropController.dispose();
    _observationsController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field Assessment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cropController,
                decoration: const InputDecoration(
                  labelText: 'Crop Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter crop type' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observationsController,
                decoration: const InputDecoration(
                  labelText: 'Observations',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter observations' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _recommendationsController,
                decoration: const InputDecoration(
                  labelText: 'Recommendations',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter recommendations' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Submit Assessment'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _submitAssessment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
