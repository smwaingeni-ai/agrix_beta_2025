// 📁 lib/services/officers/officer_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/officers/officer_task.dart';
import '../../models/officers/officer_assessment.dart';

class OfficerService {
  /// 🔹 Get the application document directory path
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 🔹 Get the local file for tasks or assessments
  static Future<File> _localFile(String fileName) async {
    final path = await _localPath();
    return File('$path/$fileName.json');
  }

  // ------------------- Task Management -------------------

  /// 🔹 Save a single officer task
  static Future<void> saveTask(OfficerTask task) async {
    try {
      final file = await _localFile('officer_tasks');
      final tasks = await loadTasks();
      tasks.add(task);
      await file.writeAsString(jsonEncode(tasks.map((t) => t.toJson()).toList()));
      print('✅ Officer task saved.');
    } catch (e) {
      print('❌ Error saving officer task: $e');
    }
  }

  /// 🔹 Load all officer tasks
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

  // ------------------- Assessment Management -------------------

  /// 🔹 Save a single officer assessment
  static Future<void> saveAssessment(OfficerAssessment assessment) async {
    try {
      final file = await _localFile('officer_assessments');
      final assessments = await loadAssessments();
      assessments.add(assessment);
      await file.writeAsString(jsonEncode(assessments.map((a) => a.toJson()).toList()));
      print('✅ Officer assessment saved.');
    } catch (e) {
      print('❌ Error saving officer assessment: $e');
    }
  }

  /// 🔹 Load all officer assessments
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
