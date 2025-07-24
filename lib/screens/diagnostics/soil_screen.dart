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

    final headers = csv.first.cast<String>();
    final dataRows = csv.skip(1);

    _soilData = dataRows.map((row) {
      return Map.fromIterables(headers, row.map((e) => e.toString()));
    }).toList();

    setState(() {});
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
    final regions = _soilData.map((e) => e['Region']!).toSet().toList();

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
                        .map((region) => DropdownMenuItem(
                              value: region,
                              child: Text(region),
                            ))
                        .toList(),
                    onChanged: _selectRegion,
                  ),
                  const SizedBox(height: 20),
                  if (_selectedResult != null) ...[
                    Text("🌱 Soil Type: ${_selectedResult!['SoilType']}", style: const TextStyle(fontSize: 16)),
                    Text("🌾 Crops: ${_selectedResult!['SuitableCrops']}"),
                    Text("🧪 Fertility: ${_selectedResult!['Fertility']}"),
                    Text("💊 Treatment: ${_selectedResult!['Treatment']}"),
                    const SizedBox(height: 16),
                    if (_selectedResult!['ImageName'] != null)
                      Image.asset(
                        "assets/soil/${_selectedResult!['ImageName']}",
                        height: 180,
                      ),
                  ],
                ],
              ),
      ),
    );
  }
}
