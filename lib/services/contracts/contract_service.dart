// lib/services/contracts/contract_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';

/// 📦 Handles local storage of contract offers using SharedPreferences
class ContractService {
  static const String _contractsKey = 'contract_offers';
  static final Uuid _uuid = Uuid();

  /// 💾 Save all contract offers to local storage
  static Future<void> saveContracts(List<ContractOffer> offers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = offers.map((e) => e.toJson()).toList();
      await prefs.setString(_contractsKey, json.encode(jsonList));
      print('[ContractService] ✅ Contracts saved (${offers.length})');
    } catch (e) {
      print('[ContractService] ❌ Failed to save contracts: $e');
    }
  }

  /// 📥 Load all contract offers from local storage
  static Future<List<ContractOffer>> loadContracts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_contractsKey);
      if (raw == null) return [];

      final decoded = json.decode(raw);
      if (decoded is! List) return [];

      return decoded
          .map((e) => ContractOffer.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('[ContractService] ❌ Failed to load contracts: $e');
      return [];
    }
  }

  /// ➕ Add a new contract offer
  static Future<void> addContract(ContractOffer offer) async {
    try {
      final offers = await loadContracts();
      offers.add(offer);
      await saveContracts(offers);
      print('[ContractService] 🆕 Added contract: ${offer.title}');
    } catch (e) {
      print('[ContractService] ❌ Failed to add contract: $e');
    }
  }

  /// ✏️ Update an existing contract by ID
  static Future<void> updateContract(ContractOffer updatedOffer) async {
    try {
      final offers = await loadContracts();
      final index = offers.indexWhere((o) => o.id == updatedOffer.id);
      if (index != -1) {
        offers[index] = updatedOffer;
        await saveContracts(offers);
        print('[ContractService] 🔄 Updated contract: ${updatedOffer.id}');
      } else {
        print('[ContractService] ⚠️ Contract not found: ${updatedOffer.id}');
      }
    } catch (e) {
      print('[ContractService] ❌ Failed to update contract: $e');
    }
  }

  /// 🔍 Get a contract offer by ID
  static Future<ContractOffer?> getContractById(String id) async {
    try {
      final offers = await loadContracts();
      final contract = offers.firstWhere(
        (offer) => offer.id == id,
        orElse: () => ContractOffer.empty(),
      );
      return contract.id.isEmpty ? null : contract;
    } catch (e) {
      print('[ContractService] ❌ Failed to get contract by ID: $e');
      return null;
    }
  }

  /// 🗑️ Delete a contract offer by ID
  static Future<void> deleteContract(String id) async {
    try {
      final offers = await loadContracts();
      final updated = offers.where((offer) => offer.id != id).toList();
      await saveContracts(updated);
      print('[ContractService] 🗑️ Deleted contract: $id');
    } catch (e) {
      print('[ContractService] ❌ Failed to delete contract: $e');
    }
  }

  // 🔁 Aliases for backward compatibility

  /// Alias for [addContract]
  static Future<void> addContractOffer(ContractOffer offer) async {
    print('[ContractService] ➕ Alias used: addContractOffer()');
    await addContract(offer);
  }

  /// Alias for [loadContracts]
  static Future<List<ContractOffer>> loadOffers() async {
    print('[ContractService] 📥 Alias used: loadOffers()');
    return await loadContracts();
  }

  /// 🆔 Generate a new unique contract ID
  static String generateId() => _uuid.v4();
}
