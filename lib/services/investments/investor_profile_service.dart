import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrix_beta_2025/models/investments/investor_profile.dart';
import 'package:agrix_beta_2025/models/investments/investor_status.dart';

class InvestorProfileService {
  static const String _storageKey = 'investor_profiles';

  /// 🔹 Save or update an investor profile
  static Future<void> saveProfile(InvestorProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadProfiles();

    final updated = [
      ...existing.where((p) => p.id != profile.id),
      profile,
    ];

    await prefs.setString(_storageKey, InvestorProfile.encode(updated));
    print('✅ InvestorProfileService: Profile saved for ${profile.name}');
  }

  /// 📥 Load all stored investor profiles
  static Future<List<InvestorProfile>> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);

    if (jsonStr == null || jsonStr.isEmpty) {
      print('ℹ️ No investor profiles found.');
      return [];
    }

    try {
      return InvestorProfile.decode(jsonStr);
    } catch (e) {
      print('❌ Failed to decode investor profiles: $e');
      return [];
    }
  }

  /// ❌ Delete a profile by ID
  static Future<void> deleteProfile(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await loadProfiles();
    final filtered = all.where((p) => p.id != id).toList();
    await prefs.setString(_storageKey, InvestorProfile.encode(filtered));
    print('🗑️ InvestorProfileService: Deleted profile $id');
  }

  /// 🔍 Find a specific investor by ID
  static Future<InvestorProfile?> findById(String id) async {
    final all = await loadProfiles();
    final found = all.firstWhere(
      (p) => p.id == id,
      orElse: () => InvestorProfile.empty(),
    );
    return found.id.isNotEmpty ? found : null;
  }

  /// 🧪 Clear all investor profiles (for testing/debug)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    print('🧹 InvestorProfileService: All profiles cleared');
  }

  /// ✅ Temporary hardcoded fallback (or default) lookup
  Future<InvestorProfile?> getInvestorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulated latency
    final mock = InvestorProfile(
      id: 'investor123',
      name: 'Jane Doe',
      email: 'jane@example.com',
      phone: '+123456789',
      interestAreas: ['Crops', 'Livestock'],
      status: InvestorStatus.open,
      registeredAt: DateTime.now(),
      contact: 'WhatsApp',
      location: 'Kenya',
    );

    if (id == mock.id) return mock;
    return await findById(id); // fallback to local store
  }
}
