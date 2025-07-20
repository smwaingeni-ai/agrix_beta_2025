import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/services/biometric_auth_service.dart';

class SessionService {
  static const _userKey = 'agrix_active_user';
  static final _secureStorage = FlutterSecureStorage();

  /// Save user session to both secure storage and session.json
  static Future<void> saveUserSession(UserModel user) async {
    try {
      // Save to secure storage
      await _secureStorage.write(key: _userKey, value: user.toRawJson());

      // Also write to session.json (file-based session)
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');
      await file.writeAsString(jsonEncode(user.toJson()));

      print('✅ User session saved');
    } catch (e) {
      print('❌ Error saving user session: $e');
    }
  }

  /// Load active user from secure storage
  static Future<UserModel?> getActiveUser() async {
    try {
      final jsonStr = await _secureStorage.read(key: _userKey);
      return jsonStr != null ? UserModel.fromRawJson(jsonStr) : null;
    } catch (e) {
      print('❌ Error loading user session: $e');
      return null;
    }
  }

  /// Clear both secure session and session.json
  static Future<void> clearSession() async {
    try {
      await _secureStorage.delete(key: _userKey);

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');
      if (await file.exists()) await file.delete();

      print('🗑️ Session cleared');
    } catch (e) {
      print('❌ Error clearing session: $e');
    }
  }

  /// Check if session.json exists and biometrics are valid
  static Future<bool> checkSession() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');

      if (!await file.exists()) {
        print('❌ No session file found');
        return false;
      }

      final contents = await file.readAsString();
      if (contents.isEmpty) return false;

      // Optional biometric check
      final isBioValid = await BiometricAuthService.authenticate();
      return isBioValid;
    } catch (e) {
      print('❌ Error checking session: $e');
      return false;
    }
  }

  /// Optional quick check for user in memory
  static Future<bool> isUserLoggedIn() async {
    final user = await getActiveUser();
    return user != null && user.id.isNotEmpty;
  }
}
