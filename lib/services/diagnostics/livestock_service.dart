import 'dart:convert';
import 'package:flutter/services.dart';

class LivestockRule {
  final String symptom;
  final String disease;
  final String treatment;
  final String species;
  final String severity;
  final double likelihoodScore;
  final String sampleImage;

  LivestockRule({
    required this.symptom,
    required this.disease,
    required this.treatment,
    required this.species,
    required this.severity,
    required this.likelihoodScore,
    required this.sampleImage,
  });

  factory LivestockRule.fromCsv(List<String> fields) {
    return LivestockRule(
      symptom: fields[0],
      disease: fields[1],
      treatment: fields[2],
      species: fields[3],
      severity: fields[4],
      likelihoodScore: double.tryParse(fields[5]) ?? 0.0,
      sampleImage: fields[6],
    );
  }

  Map<String, dynamic> toMap() => {
        'symptom': symptom,
        'disease': disease,
        'treatment': treatment,
        'species': species,
        'severity': severity,
        'likelihoodScore': likelihoodScore,
        'sampleImage': sampleImage,
      };
}

class LivestockService {
  static const String _csvPath = 'assets/data/livestock_rules.csv';
  final List<LivestockRule> _rules = [];

  /// Load rules from CSV
  Future<void> loadRules() async {
    try {
      final raw = await rootBundle.loadString(_csvPath);
      final lines = const LineSplitter().convert(raw);

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i];
        final fields = line.split(',').map((e) => e.trim()).toList();
        if (fields.length >= 7) {
          _rules.add(LivestockRule.fromCsv(fields));
        }
      }

      print('✅ LivestockService: Loaded ${_rules.length} rules.');
    } catch (e) {
      print('❌ Error loading livestock_rules.csv: $e');
    }
  }

  /// Search by partial symptom keyword(s)
  List<LivestockRule> search(String input) {
    final query = input.toLowerCase().trim();

    final matches = _rules.where((rule) {
      return rule.symptom.toLowerCase().contains(query);
    }).toList();

    // Sort by descending likelihood
    matches.sort((a, b) => b.likelihoodScore.compareTo(a.likelihoodScore));
    return matches;
  }

  /// Get all loaded rules
  List<LivestockRule> getAll() => _rules;
}
