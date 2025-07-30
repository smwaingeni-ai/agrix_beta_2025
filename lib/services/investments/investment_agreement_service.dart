import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/investments/investment_agreement.dart';

class InvestmentAgreementService {
  final String _fileName = 'investment_agreements.json';

  /// 🔍 Get app document directory path
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 📄 Get file reference
  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/$_fileName');
  }

  /// 💾 Save a new investment agreement
  Future<void> saveAgreement(InvestmentAgreement agreement) async {
    final file = await _getLocalFile();
    final existing = await loadAgreements();
    existing.add(agreement);
    final jsonList = existing.map((a) => a.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList), flush: true);
    print('✅ Agreement saved: ${agreement.agreementId}');
  }

  /// 📥 Load all saved agreements
  Future<List<InvestmentAgreement>> loadAgreements() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData
          .map((json) => InvestmentAgreement.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error loading agreements: $e');
      return [];
    }
  }

  /// 🧹 Clear all stored agreements
  Future<void> clearAgreements() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.writeAsString(jsonEncode([]), flush: true);
      print('🗑️ All investment agreements cleared');
    }
  }
}
