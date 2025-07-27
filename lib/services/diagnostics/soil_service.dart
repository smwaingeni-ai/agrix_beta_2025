// lib/services/diagnostics/soil_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

/// 🧪 SoilEntry represents a soil record from the CSV file
class SoilEntry {
  final String region;
  final String soilType;
  final String fertility;
  final String treatment;
  final String suitableCrops;
  final String imageName;

  SoilEntry({
    required this.region,
    required this.soilType,
    required this.fertility,
    required this.treatment,
    required this.suitableCrops,
    required this.imageName,
  });

  factory SoilEntry.fromCsv(List<String> fields) {
    return SoilEntry(
      region: fields[0],
      soilType: fields[1],
      fertility: fields[2],
      treatment: fields[3],
      suitableCrops: fields[4],
      imageName: 'assets/images/soil/${fields[5]}',
    );
  }

  Map<String, dynamic> toMap() => {
        'region': region,
        'soilType': soilType,
        'fertility': fertility,
        'treatment': treatment,
        'suitableCrops': suitableCrops,
        'imageName': imageName,
      };
}

/// 🌍 SoilService handles CSV-based soil classification support
class SoilService {
  static const String _csvPath = 'assets/data/soil_map_africa.csv';
  final List<SoilEntry> _entries = [];

  /// 🔄 Load and parse soil entries from CSV
  Future<void> loadSoilData() async {
    try {
      final raw = await rootBundle.loadString(_csvPath);
      final lines = const LineSplitter().convert(raw);

      for (int i = 1; i < lines.length; i++) {
        final fields = _safeSplit(lines[i]);
        if (fields.length >= 6) {
          _entries.add(SoilEntry.fromCsv(fields));
        }
      }

      print('✅ SoilService: Loaded ${_entries.length} entries');
    } catch (e) {
      print('❌ SoilService: Failed to load soil data - $e');
    }
  }

  /// 🔍 Search entries by region, soil type, or fertility keywords
  List<SoilEntry> search(String query) {
    final lower = query.toLowerCase().trim();
    return _entries.where((entry) {
      return entry.region.toLowerCase().contains(lower) ||
          entry.soilType.toLowerCase().contains(lower) ||
          entry.fertility.toLowerCase().contains(lower);
    }).toList();
  }

  /// 📦 Return all loaded soil entries
  List<SoilEntry> getAll() => _entries;

  /// 🛡️ Safe CSV split supporting quoted strings
  List<String> _safeSplit(String line) {
    return line
        .split(RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)'))
        .map((s) => s.replaceAll('"', '').trim())
        .toList();
  }
}
