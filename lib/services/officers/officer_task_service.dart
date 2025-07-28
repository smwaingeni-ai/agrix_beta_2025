// 📁 lib/services/officers/officer_task_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/officers/officer_task.dart';

/// 📝 OfficerTaskService manages persistence of officer task entries.
class OfficerTaskService {
  static const String _fileName = 'officer_tasks.json';

  /// 📁 Returns app's documents directory path
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 📄 Returns a reference to the storage file
  static Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/$_fileName');
  }

  // =============================
  // 📥 Load Tasks
  // =============================
  static Future<List<OfficerTask>> loadTasks() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(contents);
      return decoded.map((e) => OfficerTask.fromJson(e)).toList();
    } catch (e) {
      print('❌ OfficerTaskService.loadTasks: $e');
      return [];
    }
  }

  // =============================
  // 💾 Save a New Task
  // =============================
  static Future<void> saveTask(OfficerTask task) async {
    try {
      final tasks = await loadTasks();
      tasks.add(task);
      final file = await _localFile();
      await file.writeAsString(
        jsonEncode(tasks.map((t) => t.toJson()).toList()),
        flush: true,
      );
      print('✅ Officer task saved: ${task.id}');
    } catch (e) {
      print('❌ OfficerTaskService.saveTask: $e');
    }
  }

  // =============================
  // 🔁 Update an Existing Task
  // =============================
  static Future<void> updateTask(OfficerTask updatedTask) async {
    try {
      final tasks = await loadTasks();
      final index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        final file = await _localFile();
        await file.writeAsString(
          jsonEncode(tasks.map((t) => t.toJson()).toList()),
          flush: true,
        );
        print('✅ Officer task updated: ${updatedTask.id}');
      } else {
        print('⚠️ Task not found for update: ${updatedTask.id}');
      }
    } catch (e) {
      print('❌ OfficerTaskService.updateTask: $e');
    }
  }

  // =============================
  // 🗑️ Delete a Task by ID
  // =============================
  static Future<void> deleteTask(String taskId) async {
    try {
      final tasks = await loadTasks();
      tasks.removeWhere((t) => t.id == taskId);
      final file = await _localFile();
      await file.writeAsString(
        jsonEncode(tasks.map((t) => t.toJson()).toList()),
        flush: true,
      );
      print('🗑️ Officer task deleted: $taskId');
    } catch (e) {
      print('❌ OfficerTaskService.deleteTask: $e');
    }
  }

  // =============================
  // 🧹 Clear All Tasks
  // =============================
  static Future<void> clearAllTasks() async {
    try {
      final file = await _localFile();
      await file.writeAsString(jsonEncode([]), flush: true);
      print('🧹 All officer tasks cleared.');
    } catch (e) {
      print('❌ OfficerTaskService.clearAllTasks: $e');
    }
  }
}
