import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/services/auth/biometric_auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _userKey = 'agrix_active_user';
  static final FlutterSecureStorage? _secureStorage =
      !kIsWeb ? const FlutterSecureStorage() : null;

  /// 🔐 Save session to secure storage and local JSON
  static Future<void> saveUserSession(UserModel user) async {
    try {
      if (!kIsWeb && _secureStorage != null) {
        await _secureStorage!.write(key: _userKey, value: user.toRawJson());
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');
      await file.writeAsString(jsonEncode(user.toJson()));

      print('✅ User session saved${kIsWeb ? '' : ' to secure storage'} and session.json');
    } catch (e) {
      print('❌ Failed to save user session: $e');
    }
  }

  /// 📥 Load user session from secure storage or file
  static Future<UserModel?> getActiveUser() async {
    try {
      String? jsonStr;

      if (!kIsWeb && _secureStorage != null) {
        jsonStr = await _secureStorage!.read(key: _userKey);
      }

      if (jsonStr == null || jsonStr.trim().isEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/session.json');
        if (!await file.exists()) return null;

        jsonStr = await file.readAsString();
      }

      return jsonStr.trim().isNotEmpty
          ? UserModel.fromRawJson(jsonStr)
          : null;
    } catch (e) {
      print('❌ Failed to load user session: $e');
      return null;
    }
  }

  /// 🧹 Clear secure storage and file session
  static Future<void> clearSession() async {
    try {
      if (!kIsWeb && _secureStorage != null) {
        await _secureStorage!.delete(key: _userKey);
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');
      if (await file.exists()) {
        await file.delete();
        print('🗑️ session.json deleted');
      }

      print('🗑️ User session cleared');
    } catch (e) {
      print('❌ Error clearing session: $e');
    }
  }

  /// 🔐 Validate biometric + session
  static Future<bool> checkSession() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');

      if (!await file.exists()) {
        print('❌ session.json does not exist');
        return false;
      }

      final contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        print('⚠️ session.json is empty');
        return false;
      }

      final bool isBioValid = await BiometricAuthService.authenticate();
      print(isBioValid
          ? '✅ Session and biometrics validated'
          : '❌ Biometric auth failed');
      return isBioValid;
    } catch (e) {
      print('❌ Error validating session: $e');
      return false;
    }
  }

  /// 🔎 Web-safe check: user session only
  static Future<bool> isUserLoggedIn() async {
    final user = await getActiveUser();
    return user != null && user.id.trim().isNotEmpty;
  }
}
