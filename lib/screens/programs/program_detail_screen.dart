import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agrix_beta_2025/models/programs/program.dart'; // ✅ Fixed import

class ProgramDetailScreen extends StatelessWidget {
  final ProgramLog program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(program.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Program Details'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildDetailRow('📌 Program Name', program.programName),
                _buildDetailRow('👨‍🌾 Farmer', program.farmer),
                _buildDetailRow('📍 Region', program.region),
                _buildDetailRow('🛠️ Resource', program.resource),
                _buildDetailRow('🌱 Impact', program.impact),
                _buildDetailRow('🧑‍💼 Officer', program.officer),
                _buildDetailRow('📅 Date', formattedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
