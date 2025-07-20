import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:agrix_beta_2025/models/user_model.dart';
import 'package:agrix_beta_2025/services/auth/biometric_auth_service.dart';

class SessionService {
  static const _userKey = 'agrix_active_user';
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// 🔐 Save user session securely and persist to session.json
  static Future<void> saveUserSession(UserModel user) async {
    try {
      await _secureStorage.write(key: _userKey, value: user.toRawJson());

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/session.json');
      await file.writeAsString(jsonEncode(user.toJson()));

      print('✅ User session saved to secure storage and session.json');
    } catch (e) {
      print('❌ Failed to save user session: $e');
    }
  }

  /// 📥 Load active user from secure storage
  static Future<UserModel?> getActiveUser() async {
    try {
      final jsonStr = await _secureStorage.read(key: _userKey);
      if (jsonStr == null || jsonStr.trim().isEmpty) return null;
      return UserModel.fromRawJson(jsonStr);
    } catch (e) {
      print('❌ Failed to load user from secure storage: $e');
      return null;
    }
  }

  /// 🧹 Clear session from both secure storage and file
  static Future<void> clearSession() async {
    try {
      await _secureStorage.delete(key: _userKey);

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

  /// 🔎 Check if session is valid and passes biometric auth
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

  /// 🔄 Quick check for secure user presence
  static Future<bool> isUserLoggedIn() async {
    final user = await getActiveUser();
    return user != null && user.id.trim().isNotEmpty;
  }
}
