import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:agrix_beta_2025/models/loan/loan_application.dart';

/// 💼 Handles all Loan Application logic: save, load, delete, update
class LoanApplicationService {
  static const String _storageKey = 'loan_applications';

  /// 📥 Load all saved loan applications
  static Future<List<LoanApplication>> loadLoans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    return LoanApplication.decodeList(jsonStr);
  }

  /// 💾 Save the full list of loan applications
  static Future<void> saveLoans(List<LoanApplication> loans) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = LoanApplication.encodeList(loans);
    await prefs.setString(_storageKey, jsonStr);
  }

  /// ➕ Add a new loan application with UUID and current date
  static Future<void> addLoan({
    required String farmerId,
    required double amount,
    required String purpose,
    required int durationMonths,
  }) async {
    final loans = await loadLoans();
    final newLoan = LoanApplication(
      id: const Uuid().v4(),
      farmerId: farmerId,
      amount: amount,
      purpose: purpose,
      durationMonths: durationMonths,
      applicationDate: DateTime.now(),
      status: 'Pending',
    );
    loans.add(newLoan);
    await saveLoans(loans);
  }

  /// 🗑️ Delete a loan application by ID
  static Future<void> deleteLoan(String loanId) async {
    final loans = await loadLoans();
    final updated = loans.where((loan) => loan.id != loanId).toList();
    await saveLoans(updated);
  }

  /// 🔁 Update the status of a loan application
  static Future<void> updateLoanStatus(String loanId, String newStatus) async {
    final loans = await loadLoans();
    final updatedLoans = loans.map((loan) {
      if (loan.id == loanId) {
        return loan.copyWith(status: newStatus);
      }
      return loan;
    }).toList();
    await saveLoans(updatedLoans);
  }

  /// 🔍 Filter and return all loans for a given farmer
  static Future<List<LoanApplication>> getLoansForFarmer(String farmerId) async {
    final loans = await loadLoans();
    return loans.where((loan) => loan.farmerId == farmerId).toList();
  }

  /// 🧹 Clear all loans — use only for admin/debugging
  static Future<void> clearAllLoans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
