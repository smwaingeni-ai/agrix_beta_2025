// lib/services/auth/session_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:agrix_beta_2025/models/user_model.dart';

class SessionService {
  static const _userKey = 'agrix_active_user';
  static final _storage = FlutterSecureStorage();

  /// Save user session
  static Future<void> saveUserSession(UserModel user) async {
    try {
      await _storage.write(key: _userKey, value: user.toRawJson());
      print('✅ User session saved');
    } catch (e) {
      print('❌ Error saving user session: $e');
    }
  }

  /// Load user session
  static Future<UserModel?> getActiveUser() async {
    try {
      final jsonStr = await _storage.read(key: _userKey);
      return jsonStr != null ? UserModel.fromRawJson(jsonStr) : null;
    } catch (e) {
      print('❌ Error loading user session: $e');
      return null;
    }
  }

  /// Clear user session
  static Future<void> clearSession() async {
    try {
      await _storage.delete(key: _userKey);
      print('🗑️ User session cleared');
    } catch (e) {
      print('❌ Error clearing session: $e');
    }
  }

  /// Check if session exists
  static Future<bool> isUserLoggedIn() async {
    final user = await getActiveUser();
    return user != null && user.id.isNotEmpty;
  }
}
