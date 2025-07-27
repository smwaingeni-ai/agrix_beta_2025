import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:agrix_beta_2025/models/diagnostics/diagnosis.dart';

class CropDiagnosisService {
  static Future<Map<String, Diagnosis>> loadCropRules() async {
    final raw = await rootBundle.loadString('assets/data/crop_rules.csv');
    final lines = LineSplitter.split(raw).toList();
    final header = lines.first.split(',');
    final Map<String, Diagnosis> rules = {};

    for (var line in lines.skip(1)) {
      final values = _safeSplit(line);
      if (values.length != header.length) continue;

      final symptom = values[0].toLowerCase().trim();
      rules[symptom] = Diagnosis(
        symptom: values[0],
        disease: values[1],
        treatment: values[2],
        cropOrSpecies: values[3],
        severity: values[4],
        likelihood: double.tryParse(values[5]) ?? 0.5,
        imagePath: 'assets/images/crops/${values[6]}',
      );
    }

    return rules;
  }

  static List<String> _safeSplit(String line) {
    return line.split(RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)')).map((s) => s.replaceAll('"', '')).toList();
  }
}
