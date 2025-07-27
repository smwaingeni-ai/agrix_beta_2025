import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/officers/officer_profile.dart';

class OfficerProfileService {
  static const String _fileName = 'officer_profile.json';

  /// 🔹 Get the local path for storing files
  static Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 🔹 Get a reference to the officer profile file
  static Future<File> _localFile() async {
    final path = await _localPath();
    return File('$path/$_fileName');
  }

  /// 📥 Load an officer profile from the local file
  static Future<OfficerProfile?> loadProfile() async {
    try {
      final file = await _localFile();
      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return OfficerProfile.fromJson(jsonDecode(contents));
    } catch (e) {
      print('❌ Error loading officer profile: $e');
      return null;
    }
  }

  /// 💾 Save an officer profile to the local file
  static Future<void> saveProfile(OfficerProfile profile) async {
    try {
      final file = await _localFile();
      await file.writeAsString(jsonEncode(profile.toJson()), flush: true);
      print('✅ Officer profile saved.');
    } catch (e) {
      print('❌ Error saving officer profile: $e');
    }
  }

  /// 🗑️ Delete the stored officer profile
  static Future<void> deleteProfile() async {
    try {
      final file = await _localFile();
      if (await file.exists()) {
        await file.delete();
        print('🗑️ Officer profile deleted.');
      }
    } catch (e) {
      print('❌ Error deleting officer profile: $e');
    }
  }
}
