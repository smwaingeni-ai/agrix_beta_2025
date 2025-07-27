import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:agrix_beta_2025/models/farmer_profile.dart';

class FarmerProfileService {
  static const String _fileName = 'farmer_profiles.json';
  static const String _activeFileName = 'active_farmer_profile.json';

  /// 📷 Pick image from gallery or camera
  static Future<String?> pickProfileImage({bool camera = false}) async {
    try {
      final picker = ImagePicker();
      final XFile? file = camera
          ? await picker.pickImage(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.gallery);
      return file?.path;
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      return null;
    }
  }

  /// 🖼️ Build widget for profile image or fallback icon
  static Widget buildProfileImage(String? imagePath, {double size = 100}) {
    if (imagePath == null || imagePath.isEmpty || !File(imagePath).existsSync()) {
      return Icon(Icons.person, size: size, color: Colors.grey);
    }
    return ClipOval(
      child: Image.file(
        File(imagePath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.person, size: size, color: Colors.grey),
      ),
    );
  }

  /// 💾 Save or update a profile and set it active
  static Future<void> saveProfile(FarmerProfile profile) async {
    try {
      final profiles = await loadProfiles();
      profiles.removeWhere((p) => p.farmerId == profile.farmerId);
      profiles.add(profile);
      await _writeProfiles(profiles);
      await setActiveProfile(profile);
    } catch (e) {
      debugPrint('❌ Error saving profile: $e');
    }
  }

  /// 📥 Load all profiles from file
  static Future<List<FarmerProfile>> loadProfiles() async {
    try {
      final file = await _getLocalFile(_fileName);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final decoded = jsonDecode(content);
      if (decoded is List) {
        return decoded.map((e) => FarmerProfile.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error loading profiles: $e');
      return [];
    }
  }

  /// 🗑️ Delete a profile by ID
  static Future<void> deleteProfile(String farmerId) async {
    try {
      final profiles = await loadProfiles();
      profiles.removeWhere((p) => p.farmerId == farmerId);
      await _writeProfiles(profiles);
    } catch (e) {
      debugPrint('❌ Error deleting profile: $e');
    }
  }

  /// ♻️ Update existing profile by ID
  static Future<void> updateProfile(FarmerProfile updatedProfile) async {
    try {
      final profiles = await loadProfiles();
      final index = profiles.indexWhere((p) => p.farmerId == updatedProfile.farmerId);
      if (index != -1) {
        profiles[index] = updatedProfile;
        await _writeProfiles(profiles);
      }
    } catch (e) {
      debugPrint('❌ Error updating profile: $e');
    }
  }

  /// 🔎 Check if profile exists
  static Future<bool> profileExists(String farmerId) async {
    final profiles = await loadProfiles();
    return profiles.any((p) => p.farmerId == farmerId);
  }

  /// 💾 Save currently active profile
  static Future<void> saveActiveProfile(FarmerProfile profile) async {
    try {
      final file = await _getLocalFile(_activeFileName);
      await file.writeAsString(jsonEncode(profile.toJson()));
    } catch (e) {
      debugPrint('❌ Error saving active profile: $e');
    }
  }

  /// ✅ Set active profile
  static Future<void> setActiveProfile(FarmerProfile profile) async {
    await saveActiveProfile(profile);
  }

  /// 📤 Load active profile
  static Future<FarmerProfile?> loadActiveProfile() async {
    try {
      final file = await _getLocalFile(_activeFileName);
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      return FarmerProfile.fromJson(jsonDecode(content));
    } catch (e) {
      debugPrint('❌ Error loading active profile: $e');
      return null;
    }
  }

  /// ❌ Clear active profile from storage
  static Future<void> clearActiveProfile() async {
    try {
      final file = await _getLocalFile(_activeFileName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('❌ Error clearing active profile: $e');
    }
  }

  /// 📁 Get local file reference
  static Future<File> _getLocalFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$filename');
  }

  /// 💾 Write profile list to file
  static Future<void> _writeProfiles(List<FarmerProfile> profiles) async {
    final file = await _getLocalFile(_fileName);
    final json = FarmerProfile.encode(profiles);
    await file.writeAsString(json);
  }
}
