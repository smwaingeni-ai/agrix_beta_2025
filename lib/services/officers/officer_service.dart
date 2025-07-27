import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/officers/officer_task.dart';
import 'package:agrix_beta_2025/models/officers/officer_assessment.dart';

/// 🛠️ OfficerService handles storage and retrieval of officer tasks and assessments.
class OfficerService {
  // 🔹 Get the local app storage path
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 🔹 Get file reference by name
  static Future<File> _localFile(String fileName) async {
    final path = await _localPath();
    return File('$path/$fileName.json');
  }

  // ==========================
  // 📋 Officer Tasks
  // ==========================

  /// Save a new task to local storage
  static Future<void> saveTask(OfficerTask task) async {
    try {
      final file = await _localFile('officer_tasks');
      final tasks = await loadTasks();
      tasks.add(task);
      await file.writeAsString(jsonEncode(tasks.map((t) => t.toJson()).toList()), flush: true);
      print('✅ Officer task saved.');
    } catch (e) {
      print('❌ Error saving officer task: $e');
    }
  }

  /// Load all saved tasks
  static Future<List<OfficerTask>> loadTasks() async {
    try {
      final file = await _localFile('officer_tasks');
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(contents);
      return decoded.map((e) => OfficerTask.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error loading officer tasks: $e');
      return [];
    }
  }

  // ==========================
  // 📊 Officer Assessments
  // ==========================

  /// Save a new assessment to local storage
  static Future<void> saveAssessment(OfficerAssessment assessment) async {
    try {
      final file = await _localFile('officer_assessments');
      final assessments = await loadAssessments();
      assessments.add(assessment);
      await file.writeAsString(jsonEncode(assessments.map((a) => a.toJson()).toList()), flush: true);
      print('✅ Officer assessment saved.');
    } catch (e) {
      print('❌ Error saving officer assessment: $e');
    }
  }

  /// Load all saved assessments
  static Future<List<OfficerAssessment>> loadAssessments() async {
    try {
      final file = await _localFile('officer_assessments');
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(contents);
      return decoded.map((e) => OfficerAssessment.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error loading officer assessments: $e');
      return [];
    }
  }
}
