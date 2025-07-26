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
      final map = {for (var i = 0; i < headers.length; i++) headers[i]: row[i].toString()};

      if (map['symptom'].toLowerCase().contains(input)) {
        results.add(map);
      }
    }

    results.sort((a, b) =>
        double.parse(b['likelihoodscore']).compareTo(double.parse(a['likelihoodscore'])));

    setState(() => _matches = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🐄 Livestock Diagnosis')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _symptomController,
              decoration: const InputDecoration(
                labelText: 'Enter symptom (e.g. diarrhea, nasal, hoof)',
                border: OutlineInputBorder(),
              ),
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
                  ? const Text('No matches yet.')
                  : ListView.builder(
                      itemCount: _matches.length,
                      itemBuilder: (_, index) {
                        final m = _matches[index];
                        return Card(
                          child: ListTile(
                            title: Text("🦠 ${m['disease']} (${m['species']})"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("💊 Treatment: ${m['treatment']}"),
                                Text("⚠️ Severity: ${m['severity']}"),
                                Text("📊 Likelihood: ${m['likelihoodscore']}"),
                              ],
                            ),
                            trailing: m['sampleimage'] != null
                                ? Image.asset('assets/images/livestock/${m['sampleimage']}', width: 50)
                                : null,
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
