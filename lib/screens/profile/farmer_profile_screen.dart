import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrix_beta_2025/models/farmer_profile.dart';

class FarmerProfileService {
  static const String _fileName = 'farmer_profiles.json';
  static const String _activeFileName = 'active_farmer_profile.json';

  static Future<String?> pickProfileImage({bool camera = false}) async {
    final picker = ImagePicker();
    final XFile? file = camera
        ? await picker.pickImage(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }

  static Widget buildProfileImage(String? imagePath, {double size = 100}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Icon(Icons.person, size: size);
    }
    return Image.file(File(imagePath), width: size, height: size, fit: BoxFit.cover);
  }

  static Future<void> saveProfile(FarmerProfile profile) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    final profiles = await loadProfiles();
    final existing = profiles.where((p) => p.farmerId == profile.farmerId).toList();
    if (existing.isNotEmpty) {
      profiles.remove(existing.first);
    }
    profiles.add(profile);
    final json = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await file.writeAsString(json);

    // Set as active
    await setActiveProfile(profile);
  }

  static Future<List<FarmerProfile>> loadProfiles() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_fileName');
      if (!file.existsSync()) return [];
      final content = await file.readAsString();
      final decoded = jsonDecode(content) as List;
      return decoded.map((e) => FarmerProfile.fromJson(e)).toList();
    } catch (e) {
      print('Error loading profiles: $e');
      return [];
    }
  }

  static Future<void> setActiveProfile(FarmerProfile profile) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_activeFileName');
    await file.writeAsString(jsonEncode(profile.toJson()));
  }

  static Future<FarmerProfile?> loadActiveProfile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_activeFileName');
      if (!file.existsSync()) return null;
      final content = await file.readAsString();
      return FarmerProfile.fromJson(jsonDecode(content));
    } catch (e) {
      print('Error loading active profile: $e');
      return null;
    }
  }

  static Future<void> clearActiveProfile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_activeFileName');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
