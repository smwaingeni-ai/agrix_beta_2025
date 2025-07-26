import 'dart:convert';
import 'package:flutter/services.dart';

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
      imageName: fields[5],
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

class SoilService {
  static const String _csvPath = 'assets/data/soil_map_africa.csv';
  final List<SoilEntry> _entries = [];

  /// Load and parse CSV entries
  Future<void> loadSoilData() async {
    try {
      final raw = await rootBundle.loadString(_csvPath);
      final lines = const LineSplitter().convert(raw);

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i];
        final fields = line.split(',').map((e) => e.trim()).toList();
        if (fields.length >= 6) {
          _entries.add(SoilEntry.fromCsv(fields));
        }
      }
      print('✅ SoilService: Loaded ${_entries.length} soil entries.');
    } catch (e) {
      print('❌ Error loading soil CSV: $e');
    }
  }

  /// Search for matching soils based on user input
  List<SoilEntry> search(String query) {
    final lower = query.toLowerCase().trim();

    return _entries.where((entry) {
      return entry.region.toLowerCase().contains(lower) ||
          entry.soilType.toLowerCase().contains(lower) ||
          entry.fertility.toLowerCase().contains(lower);
    }).toList();
  }

  /// Get all loaded entries (optional)
  List<SoilEntry> getAll() => _entries;
}
