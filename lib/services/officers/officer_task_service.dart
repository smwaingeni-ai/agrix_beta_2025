import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/officers/officer_task.dart';

class OfficerTaskService {
  static const String _fileName = 'officer_tasks.json';

  /// 🔹 Get application document directory path
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 🔹 Get local file for storing officer tasks
  static Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/$_fileName');
  }

  /// 🔹 Load all officer tasks from local file
  static Future<List<OfficerTask>> loadTasks() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(contents);
      return decoded.map((e) => OfficerTask.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error loading officer tasks: $e');
      return [];
    }
  }

  /// 🔹 Save a new officer task
  static Future<void> saveTask(OfficerTask task) async {
    try {
      final file = await _localFile();
      final tasks = await loadTasks();
      tasks.add(task);
      await file.writeAsString(jsonEncode(tasks.map((t) => t.toJson()).toList()));
      print('✅ Officer task saved.');
    } catch (e) {
      print('❌ Error saving officer task: $e');
    }
  }

  /// 🔹 Update an existing officer task by ID
  static Future<void> updateTask(OfficerTask updatedTask) async {
    try {
      final file = await _localFile();
      final tasks = await loadTasks();
      final index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        await file.writeAsString(jsonEncode(tasks.map((t) => t.toJson()).toList()));
        print('✅ Officer task updated.');
      }
    } catch (e) {
      print('❌ Error updating officer task: $e');
    }
  }

  /// 🔹 Delete an officer task by ID
  static Future<void> deleteTask(String taskId) async {
    try {
      final file = await _localFile();
      final tasks = await loadTasks();
      tasks.removeWhere((t) => t.id == taskId);
      await file.writeAsString(jsonEncode(tasks.map((t) => t.toJson()).toList()));
      print('🗑️ Officer task deleted.');
    } catch (e) {
      print('❌ Error deleting officer task: $e');
    }
  }

  /// 🔹 Clear all saved officer tasks
  static Future<void> clearAllTasks() async {
    try {
      final file = await _localFile();
      await file.writeAsString(jsonEncode([]));
      print('🧹 All officer tasks cleared.');
    } catch (e) {
      print('❌ Error clearing officer tasks: $e');
    }
  }
}
