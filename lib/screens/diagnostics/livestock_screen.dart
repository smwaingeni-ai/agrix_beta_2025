import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:csv/csv.dart';

class LivestockScreen extends StatefulWidget {
  const LivestockScreen({super.key});

  @override
  State<LivestockScreen> createState() => _LivestockScreenState();
}

class _LivestockScreenState extends State<LivestockScreen> {
  final TextEditingController _symptomController = TextEditingController();
  List<Map<String, dynamic>> _matches = [];

  Future<void> _searchDiagnosis() async {
    final input = _symptomController.text.trim().toLowerCase();
    if (input.isEmpty) return;

    final csvRaw = await rootBundle.loadString('assets/data/livestock_rules.csv');
    final csvList = const CsvToListConverter().convert(csvRaw, eol: '\n');

    final headers = csvList.first.map((e) => e.toString().toLowerCase()).toList();
    final data = csvList.skip(1);

    List<Map<String, dynamic>> results = [];

    for (final row in data) {
      final map = {
        for (var i = 0; i < headers.length; i++) headers[i]: row[i].toString()
      };

      if (map['symptom'].toLowerCase().contains(input)) {
        results.add(map);
      }
    }

    results.sort((a, b) => double.parse(b['likelihoodscore'])
        .compareTo(double.parse(a['likelihoodscore'])));

    setState(() => _matches = results);
  }

  Widget _buildDiagnosisCard(Map<String, dynamic> m) {
    final imagePath = m['sampleimage']?.isNotEmpty == true
        ? 'assets/images/livestock/${m['sampleimage']}'
        : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: imagePath != null
            ? Image.asset(imagePath, width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported))
            : const Icon(Icons.pets, size: 36),
        title: Text("🦠 ${m['disease']} (${m['species']})",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("💊 Treatment: ${m['treatment']}"),
            Text("⚠️ Severity: ${m['severity']}"),
            Text("📊 Likelihood: ${m['likelihoodscore']}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐄 Livestock Diagnosis'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _symptomController,
              decoration: const InputDecoration(
                labelText: 'Enter symptom (e.g. nasal, cough, hoof)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchDiagnosis(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _searchDiagnosis,
              icon: const Icon(Icons.search),
              label: const Text('Diagnose'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _matches.isEmpty
                  ? const Center(child: Text('🔍 No results yet. Enter a symptom to begin.'))
                  : ListView.builder(
                      itemCount: _matches.length,
                      itemBuilder: (_, index) => _buildDiagnosisCard(_matches[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
