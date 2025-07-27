// lib/services/auth/pin_auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PinAuthService {
  static const String _pinKey = 'user_pin';

  /// 🔐 Save a new PIN (e.g. after user registers or resets PIN)
  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  /// 🔎 Retrieve the saved PIN (for internal checks or admin features)
  static Future<String?> getSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  /// 📌 Check if a PIN is already set
  static Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pinKey);
  }

  /// ✅ Validate entered PIN against stored PIN
  static Future<bool> validatePin(String enteredPin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_pinKey);
    return savedPin != null && enteredPin == savedPin;
  }

  /// 🔄 Reset/Delete the stored PIN (e.g. logout or change user)
  static Future<void> clearPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
  }
}
