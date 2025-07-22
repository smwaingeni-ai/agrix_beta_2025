import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/programs/program_log.dart';

class ProgramDetailScreen extends StatelessWidget {
  final ProgramLog program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(program.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Program Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('📌 Program Name:', program.programName),
                const SizedBox(height: 12),
                _buildDetailRow('👨‍🌾 Farmer:', program.farmer),
                const SizedBox(height: 12),
                _buildDetailRow('📍 Region:', program.region),
                const SizedBox(height: 12),
                _buildDetailRow('🛠️ Resource:', program.resource),
                const SizedBox(height: 12),
                _buildDetailRow('🌱 Impact:', program.impact),
                const SizedBox(height: 12),
                _buildDetailRow('🧑‍💼 Officer:', program.officer),
                const SizedBox(height: 12),
                _buildDetailRow('📅 Date:', formattedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : 'N/A',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
