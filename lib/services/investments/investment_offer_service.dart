import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';

class InvestmentOfferService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('investment_offers');

  /// 🔹 Save or update an investment offer in Firestore
  Future<void> saveOffer(InvestmentOffer offer) async {
    try {
      await _collection
          .doc(offer.id)
          .set(offer.toJson(), SetOptions(merge: true));
      print('✅ Investment offer saved: ${offer.id}');
    } catch (e, stack) {
      print('❌ Error saving offer: $e');
      print(stack);
      rethrow;
    }
  }

  /// 🔹 Load all investment offers
  Future<List<InvestmentOffer>> loadAllOffers() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return InvestmentOffer.fromJson(data);
      }).toList();
    } catch (e, stack) {
      print('❌ Error loading investment offers: $e');
      print(stack);
      return [];
    }
  }

  /// 🔹 Get investment offer by ID
  Future<InvestmentOffer?> getOfferById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return InvestmentOffer.fromJson(data);
      }
      print('ℹ️ Offer not found for ID: $id');
      return null;
    } catch (e, stack) {
      print('❌ Error getting offer: $e');
      print(stack);
      return null;
    }
  }

  /// 🔹 Delete an investment offer by ID
  Future<void> deleteOffer(String id) async {
    try {
      await _collection.doc(id).delete();
      print('🗑️ Investment offer deleted: $id');
    } catch (e, stack) {
      print('❌ Error deleting offer: $e');
      print(stack);
      rethrow;
    }
  }

  /// 🔹 Load offers filtered by party ID (investor or farmer)
  Future<List<InvestmentOffer>> loadOffersByParty(String partyId) async {
    try {
      final snapshot =
          await _collection.where('parties', arrayContains: partyId).get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return InvestmentOffer.fromJson(data);
      }).toList();
    } catch (e, stack) {
      print('❌ Error loading offers by party: $e');
      print(stack);
      return [];
    }
  }
}
