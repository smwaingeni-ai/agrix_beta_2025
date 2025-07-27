// lib/services/diagnostics/livestock_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

/// 🐄 Rule representing a livestock symptom-disease-treatment mapping
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
      sampleImage: 'assets/images/livestock/${fields[6]}',
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

/// 🧠 LivestockService for loading and searching rules
class LivestockService {
  static const String _csvPath = 'assets/data/livestock_rules.csv';
  final List<LivestockRule> _rules = [];

  /// 🔄 Load CSV rules from assets
  Future<void> loadRules() async {
    try {
      final raw = await rootBundle.loadString(_csvPath);
      final lines = const LineSplitter().convert(raw);

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i];
        final fields = _safeSplit(line);
        if (fields.length >= 7) {
          _rules.add(LivestockRule.fromCsv(fields));
        }
      }

      print('✅ LivestockService: Loaded ${_rules.length} rules');
    } catch (e) {
      print('❌ LivestockService: Error loading rules - $e');
    }
  }

  /// 🔍 Search rules by partial symptom input
  List<LivestockRule> search(String input) {
    final query = input.toLowerCase().trim();
    final matches = _rules.where((rule) =>
        rule.symptom.toLowerCase().contains(query)).toList();
    matches.sort((a, b) => b.likelihoodScore.compareTo(a.likelihoodScore));
    return matches;
  }

  /// 📦 Return all loaded rules
  List<LivestockRule> getAll() => _rules;

  /// 🛡️ Safe CSV split with support for quoted commas
  List<String> _safeSplit(String line) {
    return line
        .split(RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)'))
        .map((e) => e.replaceAll('"', '').trim())
        .toList();
  }
}
