import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OfflineCacheService {
  /// 💾 Save any Map/List data to local JSON file
  static Future<void> save(String fileName, dynamic data) async {
    try {
      final file = await _getFile(fileName);
      await file.writeAsString(json.encode(data), flush: true);
      print('💾 Cached: $fileName');
    } catch (e) {
      print('❌ Error caching $fileName: $e');
    }
  }

  /// 📥 Load JSON file into Map/List
  static Future<dynamic> load(String fileName) async {
    try {
      final file = await _getFile(fileName);
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      return json.decode(content);
    } catch (e) {
      print('❌ Error loading $fileName: $e');
      return null;
    }
  }

  /// 🗑️ Delete cached file
  static Future<void> clear(String fileName) async {
    try {
      final file = await _getFile(fileName);
      if (await file.exists()) {
        await file.delete();
        print('🧹 Cleared cache: $fileName');
      }
    } catch (e) {
      print('❌ Error clearing $fileName: $e');
    }
  }

  /// 📁 Resolve full file path in local documents directory
  static Future<File> _getFile(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name.json');
  }
}
