import 'dart:convert';
import 'package:flutter/services.dart';

class CropRule {
  final String symptom;
  final String disease;
  final String treatment;
  final String crop;
  final String severity;
  final double likelihood;
  final String image;

  CropRule({
    required this.symptom,
    required this.disease,
    required this.treatment,
    required this.crop,
    required this.severity,
    required this.likelihood,
    required this.image,
  });

  factory CropRule.fromCsv(Map<String, dynamic> map) {
    return CropRule(
      symptom: map['Symptom'] ?? '',
      disease: map['Disease'] ?? '',
      treatment: map['Treatment'] ?? '',
      crop: map['Crop'] ?? '',
      severity: map['Severity'] ?? '',
      likelihood: double.tryParse(map['LikelihoodScore'] ?? '0.0') ?? 0.0,
      image: map['SampleImage'] ?? '',
    );
  }
}

class CropRuleService {
  static Future<List<CropRule>> loadRules() async {
    final raw = await rootBundle.loadString('assets/data/crop_rules.csv');
    final lines = LineSplitter.split(raw).toList();

    final headers = lines.first.split(',');
    final List<CropRule> rules = [];

    for (var i = 1; i < lines.length; i++) {
      final values = lines[i].split(',');
      final map = Map.fromIterables(headers, values);
      rules.add(CropRule.fromCsv(map));
    }

    return rules;
  }
}
