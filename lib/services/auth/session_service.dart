import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/services/auth/biometric_auth_service.dart';

class SessionService {
  static const _userKey = 'active_user';
  static final FlutterSecureStorage? _secureStorage =
      !kIsWeb ? const FlutterSecureStorage() : null;

  /// ✅ Save active user (across all roles) into SharedPreferences, SecureStorage, and file
  static Future<void> saveActiveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final raw = jsonEncode({
        'id': user.id,
        'name': user.name,
        'role': user.role,
        'passcode': user.passcode,
        'email': user.email,
        'phone': user.phone,
      });

      await prefs.setString(_userKey, raw);

      if (!kIsWeb && _secureStorage != null) {
        await _secureStorage!.write(key: _userKey, value: raw);
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');
      await file.writeAsString(raw);

      debugPrint('✅ Active user saved (name: ${user.name}, role: ${user.role})');
    } catch (e) {
      debugPrint('❌ Failed to save active user: $e');
    }
  }

  /// ✅ Lightweight login check
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  /// ✅ Load from SharedPreferences
  static Future<UserModel?> loadActiveUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_userKey);
      if (raw == null) return null;

      final json = jsonDecode(raw);
      return UserModel.fromJson(json);
    } catch (e) {
      debugPrint('❌ Failed to load active user: $e');
      return null;
    }
  }

  /// ✅ Load from SharedPreferences or local file (cross-platform fallback)
  static Future<UserModel?> getActiveUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonStr = prefs.getString(_userKey);

      if ((jsonStr == null || jsonStr.isEmpty) && !kIsWeb) {
        final file = File('${(await getApplicationDocumentsDirectory()).path}/session.json');
        if (await file.exists()) {
          jsonStr = await file.readAsString();
        }
      }

      if (jsonStr == null || jsonStr.isEmpty) return null;

      final json = jsonDecode(jsonStr);
      return UserModel.fromJson(json);
    } catch (e) {
      debugPrint('❌ getActiveUser() failed: $e');
      return null;
    }
  }

  /// 🧹 Clear all session layers
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);

      if (!kIsWeb && _secureStorage != null) {
        await _secureStorage!.delete(key: _userKey);
      }

      final file = File('${(await getApplicationDocumentsDirectory()).path}/session.json');
      if (await file.exists()) {
        await file.delete();
      }

      debugPrint('🧹 Session cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing session: $e');
    }
  }

  /// 🔐 Validate session using biometrics (only if available and file exists)
  static Future<bool> checkSession() async {
    try {
      final file = File('${(await getApplicationDocumentsDirectory()).path}/session.json');
      if (!await file.exists()) return false;

      final content = await file.readAsString();
      if (content.trim().isEmpty) return false;

      final isBioValid = await BiometricAuthService.authenticate();
      return isBioValid;
    } catch (e) {
      debugPrint('❌ Biometric session check failed: $e');
      return false;
    }
  }
}
