// lib/services/investments/investment_agreement_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/investments/investment_agreement.dart';

class InvestmentAgreementService {
  final String _fileName = 'investment_agreements.json';

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/$_fileName');
  }

  Future<void> saveAgreement(InvestmentAgreement agreement) async {
    final file = await _getLocalFile();
    List<InvestmentAgreement> agreements = await loadAgreements();
    agreements.add(agreement);
    final jsonList = agreements.map((a) => a.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<List<InvestmentAgreement>> loadAgreements() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => InvestmentAgreement.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearAgreements() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      await file.writeAsString(jsonEncode([]));
    }
  }
}
