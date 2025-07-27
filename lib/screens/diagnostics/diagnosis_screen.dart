import 'dart:io';
import 'package:flutter/material.dart';

/// ✅ Final DiagnosisScreen for Crop/Livestock Display
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
    final hasImage = image != null && image!.existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌾 Diagnosis Result'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(image!, height: 220, fit: BoxFit.cover),
              ),
            if (hasImage) const SizedBox(height: 20),
            Card(
              color: Colors.green.shade50,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🧾 Diagnosis Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('🌿 Symptom', diagnosis['symptom']),
                    _buildInfoRow('🦠 Disease', diagnosis['disease']),
                    _buildInfoRow('💊 Treatment', diagnosis['treatment']),
                    _buildInfoRow('🌾 Crop / Species',
                        diagnosis['crop'] ?? diagnosis['species']),
                    _buildInfoRow('📈 Severity', diagnosis['severity']),
                    _buildInfoRow('📊 Likelihood', '${diagnosis['likelihood'] ?? 'N/A'}'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString().isNotEmpty == true ? value! : 'Unknown',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
