import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/investor_profile.dart';

class CloudInvestorService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('investors');

  /// 🔹 Save or update an investor profile to Firestore
  Future<void> saveInvestor(InvestorProfile profile) async {
    try {
      await _collection
          .doc(profile.id)
          .set(profile.toJson(), SetOptions(merge: true));
      print('✅ Investor saved to cloud: ${profile.id}');
    } catch (e, stack) {
      print('❌ Failed to save investor: $e');
      print(stack);
      rethrow;
    }
  }

  /// 🔹 Load all investor profiles from Firestore
  Future<List<InvestorProfile>> loadInvestors() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return InvestorProfile.fromJson(data);
      }).toList();
    } catch (e, stack) {
      print('❌ Failed to load investors: $e');
      print(stack);
      return [];
    }
  }

  /// 🔹 Delete an investor profile by ID
  Future<void> deleteInvestor(String id) async {
    try {
      await _collection.doc(id).delete();
      print('🗑️ Investor deleted: $id');
    } catch (e, stack) {
      print('❌ Failed to delete investor: $e');
      print(stack);
      rethrow;
    }
  }

  /// 🔹 Fetch a single investor by ID
  Future<InvestorProfile?> getInvestorById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return InvestorProfile.fromJson(data);
      }
      print('ℹ️ No investor found for ID: $id');
      return null;
    } catch (e, stack) {
      print('❌ Failed to fetch investor: $e');
      print(stack);
      return null;
    }
  }
}
