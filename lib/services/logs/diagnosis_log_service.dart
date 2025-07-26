import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DiagnosisLogService {
  static const String _fileName = 'diagnosis_log.json';

  /// Append a diagnosis record to local log
  static Future<void> log(Map<String, dynamic> record) async {
    final file = await _getLogFile();
    List<Map<String, dynamic>> existing = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      existing = List<Map<String, dynamic>>.from(json.decode(content));
    }

    existing.add(record);
    await file.writeAsString(json.encode(existing), flush: true);
    print('📝 Log saved: ${record['type']} – ${record['label'] ?? record['disease']}');
  }

  /// Load all diagnosis logs
  static Future<List<Map<String, dynamic>>> loadAll() async {
    final file = await _getLogFile();
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    return List<Map<String, dynamic>>.from(json.decode(content));
  }

  static Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }
}
