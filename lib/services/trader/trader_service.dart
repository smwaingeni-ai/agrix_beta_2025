import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:agrix_beta_2025/models/trader/trader_profile.dart';

class TraderService {
  static const String _dataPath = 'assets/data/traders.json';

  Future<List<TraderProfile>> loadTraderProfiles() async {
    final jsonString = await rootBundle.loadString(_dataPath);
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((json) => TraderProfile.fromJson(json)).toList();
  }

  Future<TraderProfile?> getTraderById(String id) async {
    final profiles = await loadTraderProfiles();
    return profiles.firstWhere((trader) => trader.traderId == id, orElse: () => null);
  }
}
