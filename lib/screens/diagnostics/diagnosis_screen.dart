import 'dart:io';
import 'package:flutter/material.dart';

class DiagnosisScreen extends StatelessWidget {
  final Map<String, dynamic> diagnosis;
  final File? image;

  const DiagnosisScreen({
    Key? key,
    required this.diagnosis,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌾 Crop Diagnosis'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (image != null)
              Image.file(image!, height: 200),
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('🌿 Symptom', diagnosis['symptom']),
                    _buildInfoRow('🦠 Disease', diagnosis['disease']),
                    _buildInfoRow('💊 Treatment', diagnosis['treatment']),
                    _buildInfoRow('🌱 Crop', diagnosis['crop']),
                    _buildInfoRow('📈 Severity', diagnosis['severity']),
                    _buildInfoRow('📊 Likelihood', '${diagnosis['likelihood']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Unknown')),
        ],
      ),
    );
  }
}
