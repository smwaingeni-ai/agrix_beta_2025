import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/contracts/contract_offer.dart';

class ContractService {
  static const String _contractsKey = 'contract_offers';
  static final Uuid _uuid = Uuid();

  /// Save all contract offers to local storage
  static Future<void> saveContracts(List<ContractOffer> offers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = offers.map((e) => e.toJson()).toList();
      await prefs.setString(_contractsKey, json.encode(jsonList));
      print('[ContractService] Contracts saved (${offers.length} items)');
    } catch (e) {
      print('[ContractService] Error saving contracts: $e');
    }
  }

  /// Load all contract offers from local storage
  static Future<List<ContractOffer>> loadContracts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_contractsKey);
      if (raw == null) return [];

      final decoded = json.decode(raw);
      if (decoded is! List) return [];

      final offers = decoded
          .map((e) => ContractOffer.fromJson(e))
          .whereType<ContractOffer>()
          .toList();
      print('[ContractService] Loaded ${offers.length} contracts');
      return offers;
    } catch (e) {
      print('[ContractService] Error loading contracts: $e');
      return [];
    }
  }

  /// Add a new contract offer to local storage
  static Future<void> addContract(ContractOffer offer) async {
    try {
      final offers = await loadContracts();
      offers.add(offer);
      await saveContracts(offers);
      print('[ContractService] Added new contract: ${offer.title}');
    } catch (e) {
      print('[ContractService] Error adding contract: $e');
    }
  }

  /// Update an existing contract offer by ID
  static Future<void> updateContract(ContractOffer updatedOffer) async {
    try {
      final offers = await loadContracts();
      final index = offers.indexWhere((o) => o.id == updatedOffer.id);
      if (index != -1) {
        offers[index] = updatedOffer;
        await saveContracts(offers);
        print('[ContractService] Updated contract: ${updatedOffer.id}');
      } else {
        print('[ContractService] Contract not found: ${updatedOffer.id}');
      }
    } catch (e) {
      print('[ContractService] Error updating contract: $e');
    }
  }

  /// Retrieve a contract offer by ID
  static Future<ContractOffer?> getContractById(String id) async {
    try {
      final offers = await loadContracts();
      final contract = offers.firstWhere(
        (offer) => offer.id == id,
        orElse: () => ContractOffer.empty(),
      );
      if (contract.id.isEmpty) return null;
      return contract;
    } catch (e) {
      print('[ContractService] Error retrieving contract by ID: $e');
      return null;
    }
  }

  /// Delete a contract offer by ID
  static Future<void> deleteContract(String id) async {
    try {
      final offers = await loadContracts();
      final updated = offers.where((offer) => offer.id != id).toList();
      await saveContracts(updated);
      print('[ContractService] Deleted contract: $id');
    } catch (e) {
      print('[ContractService] Error deleting contract: $e');
    }
  }

  // 🔁 Aliases for compatibility and backward usage

  /// Alias for addContract()
  static Future<void> addContractOffer(ContractOffer offer) async {
    print('[ContractService] Alias: addContractOffer called');
    await addContract(offer);
  }

  /// Alias for loadContracts()
  static Future<List<ContractOffer>> loadOffers() async {
    print('[ContractService] Alias: loadOffers called');
    return await loadContracts();
  }
}
