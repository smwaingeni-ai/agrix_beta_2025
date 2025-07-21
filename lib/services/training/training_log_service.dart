import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrix_beta_2025/models/training/training_log.dart';

class TrainingLogService {
  static const String _storageKey = 'training_logs';

  /// 🔹 Load all saved training logs
  static Future<List<TrainingLog>> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_storageKey) ?? [];
    final logs = <TrainingLog>[];

    for (final item in rawList) {
      try {
        final jsonMap = json.decode(item);
        logs.add(TrainingLog.fromJson(jsonMap));
      } catch (e) {
        // You may log the error for diagnostics
      }
    }

    return logs;
  }

  /// 🔹 Save a new training log (adds to beginning of list)
  static Future<void> saveLog(TrainingLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await loadLogs();

    // Avoid duplicate IDs
    logs.removeWhere((existing) => existing.id == log.id);
    logs.insert(0, log); // newest first

    final encoded = logs.map((l) => json.encode(l.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  /// 🔹 Delete a training log by ID
  static Future<void> deleteLog(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await loadLogs();

    final updated = logs.where((log) => log.id != id).toList();
    final encoded = updated.map((l) => json.encode(l.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  /// 🔹 Clear all logs (admin/debug)
  static Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
