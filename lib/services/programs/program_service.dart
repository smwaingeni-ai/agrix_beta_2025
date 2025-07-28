import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/programs/program.dart'; // ✅ Corrected import

class ProgramService {
  static const String _fileName = 'program_logs.json';

  /// 🔹 Get local storage file
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// 🔹 Load all logs
  Future<List<ProgramLog>> loadLogs() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => ProgramLog.fromJson(json)).toList();
    } catch (e) {
      print('Error loading program logs: $e');
      return [];
    }
  }

  /// 🔹 Save all logs
  Future<void> saveLogs(List<ProgramLog> logs) async {
    try {
      final file = await _getLocalFile();
      final jsonString = jsonEncode(logs.map((log) => log.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving program logs: $e');
    }
  }

  /// 🔹 Add a new log
  Future<void> addLog(ProgramLog newLog) async {
    final logs = await loadLogs();
    logs.add(newLog);
    await saveLogs(logs);
  }

  /// 🔹 Update an existing log
  Future<void> updateLog(ProgramLog updatedLog) async {
    final logs = await loadLogs();
    final index = logs.indexWhere((log) => log.id == updatedLog.id);
    if (index != -1) {
      logs[index] = updatedLog;
      await saveLogs(logs);
    }
  }

  /// 🔹 Delete a log by ID
  Future<void> deleteLog(String id) async {
    final logs = await loadLogs();
    logs.removeWhere((log) => log.id == id);
    await saveLogs(logs);
  }

  /// 🔹 Clear all logs
  Future<void> clearAllLogs() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error clearing program logs: $e');
    }
  }
}
