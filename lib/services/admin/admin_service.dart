import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:agrix_beta_2025/models/admin/system_stats.dart';

class AdminService {
  Future<SystemStats> fetchSystemStats() async {
    try {
      final String response = await rootBundle.loadString('assets/data/system_stats.json');
      final data = json.decode(response);
      return SystemStats.fromJson(data);
    } catch (e) {
      print('Error loading system stats: $e');
      return SystemStats(
        totalFarmers: 0,
        totalInvestors: 0,
        totalContracts: 0,
        totalTasks: 0,
        totalPrograms: 0,
        totalLogs: 0,
        lastSync: DateTime.now(),
      );
    }
  }
}
