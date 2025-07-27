import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:agrix_beta_2025/models/official/official_profile.dart';

/// 🏛️ OfficialService loads government official profiles from bundled JSON
class OfficialService {
  static const String _dataPath = 'assets/data/officials.json';

  /// 🔹 Load all registered officials
  Future<List<OfficialProfile>> loadOfficials() async {
    try {
      final data = await rootBundle.loadString(_dataPath);
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((e) => OfficialProfile.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error loading official profiles: $e');
      return [];
    }
  }

  /// 🔍 Get a single official by ID
  Future<OfficialProfile?> getOfficialById(String id) async {
    final officials = await loadOfficials();
    return officials.firstWhere((o) => o.id == id, orElse: () => OfficialProfile.empty());
  }
}
