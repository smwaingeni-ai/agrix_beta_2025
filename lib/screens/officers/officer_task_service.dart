import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/tasks/task_model.dart';

class OfficerTaskService {
  static const String _fileName = 'officer_tasks.json';

  Future<void> saveTask(OfficerTask task) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    List<OfficerTask> existing = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      if (contents.isNotEmpty) {
        final decoded = jsonDecode(contents);
        existing = (decoded as List)
            .map((e) => OfficerTask.fromJson(e))
            .toList();
      }
    }

    existing.add(task);
    await file.writeAsString(jsonEncode(existing.map((e) => e.toJson()).toList()));
  }

  Future<List<OfficerTask>> loadTasks() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    if (!await file.exists()) return [];

    final contents = await file.readAsString();
    if (contents.isEmpty) return [];

    final data = jsonDecode(contents) as List;
    return data.map((e) => OfficerTask.fromJson(e)).toList();
  }
}
