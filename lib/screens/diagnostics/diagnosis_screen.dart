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
    final String disease = diagnosis['disease'] ?? 'Unknown';
    final String symptom = diagnosis['symptom'] ?? 'Unknown';
    final String treatment = diagnosis['treatment'] ?? 'N/A';
    final String crop = diagnosis['crop'] ?? 'N/A';
    final String severity = diagnosis['severity'] ?? 'N/A';
    final String likelihood = diagnosis['likelihood']?.toString() ?? 'N/A';
    final String imagePath = diagnosis['image'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌿 Crop Diagnosis'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (image != null) ...[
              Image.file(image!, height: 200),
              const SizedBox(height: 16),
            ],
            _infoRow('🦠 Disease', disease),
            _infoRow('🌿 Symptom', symptom),
            _infoRow('💊 Treatment', treatment),
            _infoRow('🌱 Crop', crop),
            _infoRow('📈 Severity', severity),
            _infoRow('📊 Likelihood', likelihood),
            const SizedBox(height: 20),
            if (imagePath.isNotEmpty)
              Image.asset('assets/images/crops/$imagePath', height: 180, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
