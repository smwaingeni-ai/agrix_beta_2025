import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/officers/officer_profile.dart';

class OfficerProfileService {
  static const String _fileName = 'officer_profile.json';

  /// 🔹 Get local path
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 🔹 Get file reference
  static Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/$_fileName');
  }

  /// 🔹 Load profile
  static Future<OfficerProfile?> loadProfile() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return OfficerProfile.fromJson(jsonDecode(contents));
    } catch (e) {
      print('❌ Error loading profile: $e');
      return null;
    }
  }

  /// 🔹 Save profile
  static Future<void> saveProfile(OfficerProfile profile) async {
    try {
      final file = await _localFile();
      await file.writeAsString(jsonEncode(profile.toJson()));
      print('✅ Officer profile saved.');
    } catch (e) {
      print('❌ Error saving profile: $e');
    }
  }

  /// 🔹 Delete profile
  static Future<void> deleteProfile() async {
    try {
      final file = await _localFile();
      if (await file.exists()) {
        await file.delete();
        print('🗑️ Officer profile deleted.');
      }
    } catch (e) {
      print('❌ Error deleting profile: $e');
    }
  }
}
