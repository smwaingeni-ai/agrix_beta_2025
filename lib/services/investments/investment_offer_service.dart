import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrix_beta_2025/models/investments/investment_offer.dart';
import 'package:agrix_beta_2025/models/investments/investment_agreement.dart';

class InvestmentOfferService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('investment_offers');

  /// 🔹 Save or update an investment offer in Firestore
  Future<void> saveOffer(InvestmentOffer offer) async {
    try {
      await _collection.doc(offer.id).set(offer.toJson(), SetOptions(merge: true));
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
      final snapshot = await _collection.where('parties', arrayContains: partyId).get();
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

  /// ✅ TEMP: Get mock offers for investor (demo/testing only)
  static Future<List<InvestmentOffer>> getOffersByInvestorId(String investorId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate DB
    return [
      InvestmentOffer(
        id: 'offer1',
        investorId: investorId,
        title: 'Wheat Fund',
        amount: 3000,
        term: '12 months',
        contact: 'WhatsApp',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        listingId: 'listing1',
        investorName: 'Jane Doe',
        interestRate: 7.5,
        isAccepted: false,
        timestamp: DateTime.now(),
        currency: 'USD',
        durationMonths: 12,
      ),
      InvestmentOffer(
        id: 'offer2',
        investorId: investorId,
        title: 'Maize Capital',
        amount: 5000,
        term: '6 months',
        contact: 'Email',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        listingId: 'listing2',
        investorName: 'Jane Doe',
        interestRate: 6.2,
        isAccepted: true,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        currency: 'USD',
        durationMonths: 6,
      ),
    ];
  }

  /// ✅ TEMP: Get mock agreements for investor (demo/testing only)
  static Future<List<InvestmentAgreement>> getAgreementsByInvestorId(String investorId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate DB
    return [
      InvestmentAgreement(
        agreementId: 'agreement1',
        offerId: 'offer1',
        investorId: investorId,
        investorName: 'Jane Doe',
        farmerId: 'farmer1',
        farmerName: 'Farmer A',
        amount: 3000,
        currency: 'USD',
        terms: 'Annual profit share',
        agreementDate: DateTime.now().subtract(const Duration(days: 30)),
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        status: 'In Progress',
        documentUrl: null,
      ),
      InvestmentAgreement(
        agreementId: 'agreement2', // ✅ FIXED from 'id'
        offerId: 'offer2',
        investorId: investorId,
        investorName: 'Jane Doe',
        farmerId: 'farmer2',
        farmerName: 'Farmer B',
        amount: 4500,
        currency: 'USD',
        terms: 'Fixed return, paid quarterly',
        agreementDate: DateTime.now().subtract(const Duration(days: 45)),
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        status: 'Completed',
        documentUrl: null,
      ),
    ];
  }
}
