import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinAuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _pinKey = 'agrix_user_pin';

  /// 🔐 Save the user PIN securely
  static Future<void> savePin(String pin) async {
    try {
      await _storage.write(key: _pinKey, value: pin);
      debugPrint('✅ PIN saved securely');
    } catch (e) {
      debugPrint('❌ Error saving PIN: $e');
    }
  }

  /// 🔑 Validate the entered PIN against the stored one
  static Future<bool> validatePin(String enteredPin) async {
    try {
      final storedPin = await _storage.read(key: _pinKey);
      final isValid = storedPin == enteredPin;
      debugPrint(isValid ? '✅ PIN validated' : '⚠️ Incorrect PIN');
      return isValid;
    } catch (e) {
      debugPrint('❌ Error reading PIN: $e');
      return false;
    }
  }

  /// 🧹 Clear the saved PIN
  static Future<void> clearPin() async {
    try {
      await _storage.delete(key: _pinKey);
      debugPrint('🗑️ PIN cleared');
    } catch (e) {
      debugPrint('❌ Error clearing PIN: $e');
    }
  }

  /// 🕵️ Check if a PIN is already set
  static Future<bool> isPinSet() async {
    try {
      final storedPin = await _storage.read(key: _pinKey);
      final exists = storedPin != null && storedPin.isNotEmpty;
      debugPrint(exists ? '🔐 PIN is set' : '❌ No PIN set');
      return exists;
    } catch (e) {
      debugPrint('❌ Error checking if PIN is set: $e');
      return false;
    }
  }
}
