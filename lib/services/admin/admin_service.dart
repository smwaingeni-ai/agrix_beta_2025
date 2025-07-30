import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:agrix_beta_2025/models/admin/system_stats.dart';

class AdminService {
  /// 🔹 Loads system stats (mocked version or from assets)
  static Future<SystemStats> getSystemStats() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return const SystemStats(
        totalUsers: 120,
        activeFarmers: 80,
        marketItems: 50,
        pendingLoans: 10,
      );
    } catch (e) {
      debugPrint('❌ getSystemStats failed: $e');
      return const SystemStats(
        totalUsers: 0,
        activeFarmers: 0,
        marketItems: 0,
        pendingLoans: 0,
      );
    }
  }

  /// 🔄 Simulates a system-wide sync
  static Future<void> runSystemSync() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('✅ System sync completed');
  }

  /// 🧹 Clears system cache (mocked for now)
  static Future<void> clearSystemCache() async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('✅ System cache cleared');
  }

  /// 📂 Loads mock data from local JSON file (fallback/test)
  Future<SystemStats> fetchSystemStats() async {
    try {
      final String response = await rootBundle.loadString('assets/data/system_stats.json');
      final data = json.decode(response);
      return SystemStats.fromJson(data);
    } catch (e) {
      debugPrint('Error loading system stats from file: $e');
      return const SystemStats(
        totalUsers: 0,
        activeFarmers: 0,
        marketItems: 0,
        pendingLoans: 0,
      );
    }
  }
}
