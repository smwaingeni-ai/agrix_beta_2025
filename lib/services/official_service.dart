import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/official_profile.dart';

class OfficialService {
  Future<List<OfficialProfile>> loadOfficials() async {
    final data = await rootBundle.loadString('assets/data/officials.json');
    final jsonResult = json.decode(data) as List;
    return jsonResult.map((e) => OfficialProfile.fromJson(e)).toList();
  }

  Future<OfficialProfile?> getOfficialById(String id) async {
    final officials = await loadOfficials();
    return officials.firstWhere((o) => o.id == id, orElse: () => null);
  }
}
