import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// 🔹 Check if biometrics are available and supported
  static Future<bool> canCheckBiometrics() async {
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return isDeviceSupported && canCheck;
    } on PlatformException catch (e) {
      print('❌ Error checking biometrics: ${e.message}');
      return false;
    }
  }

  /// 🔐 Authenticate using biometrics (with robust fallback for edge cases)
  static Future<bool> authenticate() async {
    try {
      final isAvailable = await canCheckBiometrics();
      if (!isAvailable) {
        print('⚠️ Biometrics not available or not supported on this device.');
        return false;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access AgriX',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      print('❌ Biometric authentication failed: ${e.message}');
      return false;
    } catch (e) {
      print('❌ Unexpected biometric error: $e');
      return false;
    }
  }
}
