// lib/services/contracts/contract_application_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/contracts/contract_application.dart';

class ContractApplicationService {
  static const String _storageKey = 'contract_applications';

  /// 🔄 Load applications for a specific contract offer ID
  Future<List<ContractApplication>> loadApplications(String contractId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getStringList(_storageKey) ?? [];

      return storedData
          .map((entry) {
            try {
              final decoded = json.decode(entry);
              return ContractApplication.fromJson(decoded);
            } catch (e) {
              print('[ContractApplicationService] ❌ Failed to decode application: $e');
              return null;
            }
          })
          .whereType<ContractApplication>()
          .where((app) => app.contractOfferId == contractId)
          .toList();
    } catch (e) {
      print('[ContractApplicationService] ❌ Failed to load applications: $e');
      return [];
    }
  }

  /// 📦 Load all applications (admin view)
  Future<List<ContractApplication>> loadAllApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getStringList(_storageKey) ?? [];

      return storedData
          .map((entry) {
            try {
              return ContractApplication.fromJson(json.decode(entry));
            } catch (e) {
              print('[ContractApplicationService] ❌ Invalid entry: $e');
              return null;
            }
          })
          .whereType<ContractApplication>()
          .toList();
    } catch (e) {
      print('[ContractApplicationService] ❌ Error loading all applications: $e');
      return [];
    }
  }

  /// 💾 Save a new contract application
  Future<void> saveApplication({
    required String offerId,
    required String farmerName,
    required String farmLocation,
    required String contactInfo,
    String farmerId = '',
    String email = '',
    String farmSize = '',
    String experience = '',
    String notes = '',
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList(_storageKey) ?? [];

      final application = ContractApplication(
        id: const Uuid().v4(),
        contractOfferId: offerId,
        farmerName: farmerName,
        farmerId: farmerId,
        location: farmLocation,
        phoneNumber: contactInfo,
        email: email,
        farmSize: farmSize,
        experience: experience,
        motivation: notes,
        appliedAt: DateTime.now(),
      );

      existing.add(json.encode(application.toJson()));
      await prefs.setStringList(_storageKey, existing);
      print('[ContractApplicationService] ✅ Application saved for $farmerName');
    } catch (e) {
      print('[ContractApplicationService] ❌ Failed to save application: $e');
    }
  }

  /// 🗑️ Clear all stored contract applications
  Future<void> clearAllApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      print('[ContractApplicationService] 🗑️ All applications cleared');
    } catch (e) {
      print('[ContractApplicationService] ❌ Failed to clear applications: $e');
    }
  }
}
