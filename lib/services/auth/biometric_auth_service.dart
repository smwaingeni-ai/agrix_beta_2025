import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// 🔍 Check if biometrics are available and device is supported
  static Future<bool> canCheckBiometrics() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final hasHardware = isSupported && canCheck;
      print(hasHardware
          ? '✅ Biometrics available and supported'
          : '⚠️ Biometrics not supported or unavailable');
      return hasHardware;
    } on PlatformException catch (e) {
      print('❌ Error checking biometrics: ${e.message}');
      return false;
    }
  }

  /// 🔐 Trigger biometric authentication
  /// [biometricOnly] = true means no device PIN fallback allowed
  static Future<bool> authenticate({bool biometricOnly = true}) async {
    try {
      final isAvailable = await canCheckBiometrics();
      if (!isAvailable) {
        print('⚠️ Biometrics not available or not supported on this device.');
        return false;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access AgriX',
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      print(didAuthenticate
          ? '✅ Biometric authentication successful'
          : '⚠️ Biometric authentication failed or cancelled');
      return didAuthenticate;
    } on PlatformException catch (e) {
      print('❌ Biometric auth PlatformException: ${e.message}');
      return false;
    } catch (e) {
      print('❌ Unexpected biometric error: $e');
      return false;
    }
  }
}
