import 'package:flutter/material.dart';
import 'package:agrix_africa_adt2025/models/farmer_profile.dart';

class CreditScoreScreen extends StatelessWidget {
  final FarmerProfile farmer;

  // 🔧 Removed `const` to allow runtime data (farmer) to be passed
  CreditScoreScreen({super.key, required this.farmer});

  int calculateScore(FarmerProfile farmer) {
    int score = 600;
    if (farmer.subsidised) score += 50;
    if ((farmer.farmSizeHectares ?? 0) > 5) score += 30;
    if ((farmer.region ?? '').toLowerCase().contains('irrigated')) score += 20;
    return score.clamp(300, 850);
  }

  String getScoreCategory(int score) {
    if (score >= 750) return 'Excellent';
    if (score >= 700) return 'Good';
    if (score >= 650) return 'Fair';
    return 'Needs Improvement';
  }

  Color getScoreColor(int score) {
    if (score >= 750) return Colors.green.shade700;
    if (score >= 700) return Colors.green;
    if (score >= 650) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = calculateScore(farmer);
    final category = getScoreCategory(score);
    final color = getScoreColor(score);

    return Scaffold(
      appBar: AppBar(title: const Text('📊 Credit Score')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Estimated Credit Score',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Text(
                  '$score / 850',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: color),
                ),
                const SizedBox(height: 20),
                const Text(
                  'This score is based on:\n• Farm size\n• Subsidy status\n• Region characteristics',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
