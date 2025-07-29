// lib/services/diagnostics/crop_diagnosis_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:agrix_beta_2025/models/diagnostics/diagnosis.dart';

class CropDiagnosisService {
  /// 🧠 Loads diagnostic rules from a CSV and maps symptoms to [Diagnosis] objects.
  static Future<Map<String, Diagnosis>> loadCropRules() async {
    try {
      final raw = await rootBundle.loadString('assets/data/crop_rules.csv');
      final lines = LineSplitter.split(raw).toList();
      if (lines.isEmpty) return {};

      final header = lines.first.split(',');
      final Map<String, Diagnosis> rules = {};

      for (final line in lines.skip(1)) {
        final values = _safeSplit(line);
        if (values.length != header.length) continue;

        final symptomKey = values[0].toLowerCase().trim();
        rules[symptomKey] = Diagnosis(
          symptom: values[0],
          disease: values[1],
          treatment: values[2],
          crop: values[3], // ✅ Corrected field name
          severity: values[4],
          likelihood: double.tryParse(values[5]) ?? 0.5,
          image: 'assets/images/crops/${values[6]}',
        );
      }

      print('✅ CropDiagnosisService: ${rules.length} rules loaded');
      return rules;
    } catch (e) {
      print('❌ CropDiagnosisService: Failed to load rules - $e');
      return {};
    }
  }

  /// 🔍 Safe CSV splitting that accounts for quoted commas
  static List<String> _safeSplit(String line) {
    return line
        .split(RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)'))
        .map((s) => s.replaceAll('"', '').trim())
        .toList();
  }
}
