import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OfflineCacheService {
  /// Save any object (Map or List) to a JSON file
  static Future<void> save(String fileName, dynamic data) async {
    final file = await _getFile(fileName);
    await file.writeAsString(json.encode(data), flush: true);
    print('💾 Cached $fileName');
  }

  /// Load any JSON file into Map/List
  static Future<dynamic> load(String fileName) async {
    final file = await _getFile(fileName);
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return json.decode(content);
  }

  /// Delete cache
  static Future<void> clear(String fileName) async {
    final file = await _getFile(fileName);
    if (await file.exists()) await file.delete();
  }

  static Future<File> _getFile(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name.json');
  }
}
