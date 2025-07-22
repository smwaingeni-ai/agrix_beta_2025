import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/contracts/contract_application.dart';

class ContractApplicationService {
  final String _storageKey = 'contract_applications';

  /// Loads all applications associated with a specific contract offer ID
  Future<List<ContractApplication>> loadApplicationsByOffer(String offerId) async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList(_storageKey) ?? [];

    return storedData
        .map((entry) {
          try {
            return ContractApplication.fromJson(json.decode(entry));
          } catch (_) {
            return null;
          }
        })
        .whereType<ContractApplication>()
        .where((app) => app.contractOfferId == offerId)
        .toList();
  }

  /// Loads all saved contract applications (regardless of offer)
  Future<List<ContractApplication>> loadAllApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList(_storageKey) ?? [];

    return storedData
        .map((entry) {
          try {
            return ContractApplication.fromJson(json.decode(entry));
          } catch (_) {
            return null;
          }
        })
        .whereType<ContractApplication>()
        .toList();
  }

  /// Saves a new application for a specific contract offer
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
  }

  /// Deletes all stored contract applications (optional admin use)
  Future<void> clearAllApplications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
