// lib/services/sustainability/sustainability_log_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrix_beta_2025/models/sustainability/sustainability_log.dart';

class SustainabilityLogService {
  static const String _key = 'sustainability_logs';

  Future<List<SustainabilityLog>> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((jsonItem) => SustainabilityLog.fromJson(jsonItem))
          .toList();
    }
    return [];
  }

  Future<void> saveLog(SustainabilityLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await loadLogs();
    logs.add(log);
    final jsonString = json.encode(logs.map((l) => l.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> deleteLog(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await loadLogs();
    logs.removeAt(index);
    final jsonString = json.encode(logs.map((l) => l.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
