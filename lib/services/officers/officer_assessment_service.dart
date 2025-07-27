import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/officers/officer_assessment.dart';

class OfficerAssessmentService {
  static const String _fileName = 'officer_assessments.json';

  /// 🔹 Get application document directory path
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 🔹 Get reference to the local file
  static Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/$_fileName');
  }

  /// 🔹 Load all officer assessments
  static Future<List<OfficerAssessment>> loadAssessments() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(contents);
      return decoded.map((e) => OfficerAssessment.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error loading officer assessments: $e');
      return [];
    }
  }

  /// 🔹 Save a new officer assessment
  static Future<void> saveAssessment(OfficerAssessment assessment) async {
    try {
      final file = await _localFile();
      final assessments = await loadAssessments();
      assessments.add(assessment);
      await file.writeAsString(
        jsonEncode(assessments.map((a) => a.toJson()).toList()),
      );
      print('✅ Officer assessment saved.');
    } catch (e) {
      print('❌ Error saving officer assessment: $e');
    }
  }

  /// 🔹 Update an assessment by index
  static Future<void> updateAssessment(int index, OfficerAssessment updated) async {
    try {
      final file = await _localFile();
      final assessments = await loadAssessments();
      if (index >= 0 && index < assessments.length) {
        assessments[index] = updated;
        await file.writeAsString(
          jsonEncode(assessments.map((a) => a.toJson()).toList()),
        );
        print('✅ Officer assessment updated.');
      }
    } catch (e) {
      print('❌ Error updating officer assessment: $e');
    }
  }

  /// 🔹 Delete an assessment by index
  static Future<void> deleteAssessment(int index) async {
    try {
      final file = await _localFile();
      final assessments = await loadAssessments();
      if (index >= 0 && index < assessments.length) {
        assessments.removeAt(index);
        await file.writeAsString(
          jsonEncode(assessments.map((a) => a.toJson()).toList()),
        );
        print('🗑️ Officer assessment deleted.');
      }
    } catch (e) {
      print('❌ Error deleting officer assessment: $e');
    }
  }

  /// 🔹 Clear all assessments
  static Future<void> clearAllAssessments() async {
    try {
      final file = await _localFile();
      await file.writeAsString(jsonEncode([]));
      print('🧹 All officer assessments cleared.');
    } catch (e) {
      print('❌ Error clearing officer assessments: $e');
    }
  }
}
