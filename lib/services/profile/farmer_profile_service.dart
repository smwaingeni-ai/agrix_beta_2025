import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/farmer_profile.dart';

class FarmerProfileService {
  static const String _fileName = 'farmer_profiles.json';
  static const String _activeFileName = 'active_farmer_profile.json';

  /// Picks an image from the device using camera or gallery
  static Future<String?> pickProfileImage({bool camera = false}) async {
    try {
      final picker = ImagePicker();
      final XFile? file = camera
          ? await picker.pickImage(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.gallery);
      return file?.path;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Builds a widget to show profile image or default icon
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
        errorBuilder: (_, __, ___) => Icon(Icons.person, size: size, color: Colors.grey),
      ),
    );
  }

  /// Saves the provided [FarmerProfile] to local JSON storage
  static Future<void> saveProfile(FarmerProfile profile) async {
    try {
      final profiles = await loadProfiles();
      profiles.removeWhere((p) => p.farmerId == profile.farmerId);
      profiles.add(profile);
      await _writeProfiles(profiles);
      await setActiveProfile(profile);
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }
  }

  /// Loads all farmer profiles from storage
  static Future<List<FarmerProfile>> loadProfiles() async {
    try {
      final file = await _getLocalFile(_fileName);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final decoded = jsonDecode(content) as List;
      return decoded.map((e) => FarmerProfile.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading profiles: $e');
      return [];
    }
  }

  /// Deletes a farmer profile by ID
  static Future<void> deleteProfile(String farmerId) async {
    try {
      final profiles = await loadProfiles();
      profiles.removeWhere((p) => p.farmerId == farmerId);
      await _writeProfiles(profiles);
    } catch (e) {
      debugPrint('Error deleting profile: $e');
    }
  }

  /// Updates an existing profile by ID
  static Future<void> updateProfile(FarmerProfile updatedProfile) async {
    try {
      final profiles = await loadProfiles();
      final index = profiles.indexWhere((p) => p.farmerId == updatedProfile.farmerId);
      if (index != -1) {
        profiles[index] = updatedProfile;
        await _writeProfiles(profiles);
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }

  /// Checks if a profile exists by ID
  static Future<bool> profileExists(String farmerId) async {
    final profiles = await loadProfiles();
    return profiles.any((p) => p.farmerId == farmerId);
  }

  /// Sets the current active profile
  static Future<void> setActiveProfile(FarmerProfile profile) async {
    try {
      final file = await _getLocalFile(_activeFileName);
      await file.writeAsString(jsonEncode(profile.toJson()));
    } catch (e) {
      debugPrint('Error setting active profile: $e');
    }
  }

  /// Loads the currently active profile
  static Future<FarmerProfile?> loadActiveProfile() async {
    try {
      final file = await _getLocalFile(_activeFileName);
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      return FarmerProfile.fromJson(jsonDecode(content));
    } catch (e) {
      debugPrint('Error loading active profile: $e');
      return null;
    }
  }

  /// Clears the currently active profile
  static Future<void> clearActiveProfile() async {
    try {
      final file = await _getLocalFile(_activeFileName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error clearing active profile: $e');
    }
  }

  /// Internal helper to get a reference to a local file
  static Future<File> _getLocalFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$filename');
  }

  /// Internal helper to write list of profiles to file
  static Future<void> _writeProfiles(List<FarmerProfile> profiles) async {
    final file = await _getLocalFile(_fileName);
    final json = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await file.writeAsString(json);
  }
}
