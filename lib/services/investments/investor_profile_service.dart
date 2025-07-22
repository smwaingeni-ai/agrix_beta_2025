import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrix_beta_2025/models/investments/investor_profile.dart';

class InvestorProfileService {
  static const _storageKey = 'investor_profiles';

  /// Save a new investor profile
  static Future<void> saveProfile(InvestorProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadProfiles();

    final updated = [...existing.where((p) => p.id != profile.id), profile];
    await prefs.setString(_storageKey, InvestorProfile.encode(updated));
  }

  /// Get all stored investor profiles
  static Future<List<InvestorProfile>> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    return InvestorProfile.decode(jsonStr);
  }

  /// Delete a profile by ID
  static Future<void> deleteProfile(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadProfiles();
    final filtered = all.where((p) => p.id != id).toList();
    await prefs.setString(_storageKey, InvestorProfile.encode(filtered));
  }

  /// Find a specific investor by ID
  static Future<InvestorProfile?> findById(String id) async {
    final all = await loadProfiles();
    return all.firstWhere((p) => p.id == id, orElse: () => InvestorProfile.empty());
  }

  /// Clear all investor profiles (for testing/debug)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
