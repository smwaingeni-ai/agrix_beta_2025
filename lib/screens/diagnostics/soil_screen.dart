import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:csv/csv.dart';

class SoilScreen extends StatefulWidget {
  const SoilScreen({Key? key}) : super(key: key);

  @override
  State<SoilScreen> createState() => _SoilScreenState();
}

class _SoilScreenState extends State<SoilScreen> {
  List<Map<String, String>> _soilData = [];
  String? _selectedRegion;
  Map<String, String>? _selectedResult;

  @override
  void initState() {
    super.initState();
    _loadSoilCSV();
  }

  Future<void> _loadSoilCSV() async {
    final raw = await rootBundle.loadString('assets/data/soil_map_africa.csv');
    List<List<dynamic>> csv = const CsvToListConverter().convert(raw, eol: '\n');

    final headers = csv.first.map((e) => e.toString()).toList();
    final rows = csv.skip(1);

    setState(() {
      _soilData = rows.map((row) {
        return Map.fromIterables(headers, row.map((e) => e.toString()));
      }).toList();
    });
  }

  void _selectRegion(String? region) {
    setState(() {
      _selectedRegion = region;
      _selectedResult = _soilData.firstWhere(
        (row) => row['Region']!.toLowerCase() == region!.toLowerCase(),
        orElse: () => {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final regions = _soilData.map((e) => e['Region']).whereType<String>().toSet().toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text("🧱 Soil Advisor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _soilData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Select Region"),
                    value: _selectedRegion,
                    items: regions
                        .map((region) => DropdownMenuItem(value: region, child: Text(region)))
                        .toList(),
                    onChanged: _selectRegion,
                  ),
                  const SizedBox(height: 20),
                  if (_selectedResult != null && _selectedResult!.isNotEmpty) ...[
                    _buildDetail("🌱 Soil Type", _selectedResult!['SoilType']),
                    _buildDetail("🌾 Suitable Crops", _selectedResult!['SuitableCrops']),
                    _buildDetail("🧪 Fertility", _selectedResult!['Fertility']),
                    _buildDetail("💊 Treatment", _selectedResult!['Treatment']),
                    const SizedBox(height: 12),
                    if (_selectedResult!['ImageName'] != null &&
                        _selectedResult!['ImageName']!.isNotEmpty)
                      Image.asset(
                        "assets/images/soil/${_selectedResult!['ImageName']}",
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text("⚠️ Image not found."),
                      ),
                  ] else ...[
                    const SizedBox(height: 20),
                    const Text('❌ No data found for this region.'),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label: ${value?.isNotEmpty == true ? value! : 'N/A'}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
